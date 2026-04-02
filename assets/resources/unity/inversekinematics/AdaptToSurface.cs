using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdaptToSurface
{
    public class AdaptToSurface : MonoBehaviour
    {

        protected Quaternion m_surfaceDeltaRot = Quaternion.identity;
        protected List<KeyValuePair<int, int>> m_adaptRotationToSurfaceSlopeAnimStates = new List<KeyValuePair<int, int>>();

        protected Transform m_transform;
        protected Animator m_animator;
        protected IKLegFoot m_IKlegfoot;

        protected bool m_prevValidationState = false;
        protected Quaternion m_targetRotation = Quaternion.identity;

        protected bool m_prevForceAdaptRotation = false;

        protected Vector3 m_currOffsetVec = Vector3.zero;

        protected Vector3[] m_individualHitPoints = new Vector3[2];
        RaycastHit m_cachedHit;

        public enum AlignmentAlgorithm
        {
            SIMPLE_SURFACE_NORMAL,
            COMPLEX_SURFACE_NORMAL
        }

        [System.Serializable]
        public class CustomGroundDetectionCast
        {
            public Transform targetTransform;
            public float radius;
            public float distance;
        }

        protected virtual void Awake()
        {
            m_transform = this.transform;
            m_animator = this.GetComponent<Animator>();
            m_IKlegfoot = this.GetComponent<IKLegFoot>();
        }

        protected virtual void Start()
        {
            foreach (var entry in m_forceAdaptRotationToSurfaceSlopeAnimStates)
            {
                m_adaptRotationToSurfaceSlopeAnimStates.Add(new KeyValuePair<int, int>(entry.layer, Animator.StringToHash(entry.animatorState)));
                m_IKlegfoot.tryAddToForceInvalidOnAnimatorState(entry);
            }
        }

        protected virtual void OnAnimatorIK(int layerIdx)
        {
            if (m_IKlegfoot == null) return;
            if (layerIdx != m_IKlegfoot.animatorIkPassLayerIndex) return;

            GroundedResult groundedResult = m_IKlegfoot.getGroundedResult();
            if (groundedResult == null) return;

            if (m_customGroundDetectionCastTargetOne.targetTransform != null && m_customGroundDetectionCastTargetTwo.targetTransform != null)
            {
                if (getHitPoint(m_customGroundDetectionCastTargetOne, m_transform.up, out m_cachedHit))
                {
                    m_individualHitPoints[0] = m_cachedHit.point;

                    if (getHitPoint(m_customGroundDetectionCastTargetTwo, m_transform.up, out m_cachedHit))
                    {
                        m_individualHitPoints[1] = m_cachedHit.point;

                        Vector3 vec1 = (m_individualHitPoints[0] - groundedResult.groundedPoint).normalized;
                        Vector3 vec2 = (m_individualHitPoints[1] - groundedResult.groundedPoint).normalized;
                        Vector3 groundedNormal = Vector3.Cross(vec1, vec2).normalized;

                        float groundedNormalDot = Vector3.Dot(groundedNormal, m_transform.up);
                        if (groundedNormalDot < 0)
                        {
                            groundedNormal *= -1;
                            groundedNormalDot *= -1;
                        }

                        groundedResult.groundedNormal = groundedNormal;

                        if (m_overrideMainGroundDetectionCastTarget.targetTransform != null)
                        {
                            if (getHitPoint(m_overrideMainGroundDetectionCastTarget, m_transform.up, out m_cachedHit))
                            {
                                Vector3 vec3 = (m_individualHitPoints[0] - m_cachedHit.point).normalized;
                                Vector3 vec4 = (m_individualHitPoints[1] - m_cachedHit.point).normalized;
                                Vector3 groundedNormal2 = Vector3.Cross(vec3, vec4).normalized;

                                float groundedNormalDot2 = Vector3.Dot(groundedNormal2, m_transform.up);
                                if (groundedNormalDot2 < 0)
                                {
                                    groundedNormal2 *= -1;
                                    groundedNormalDot2 *= -1;
                                }
                                
                                if(groundedNormalDot2 > groundedNormalDot) groundedResult.groundedNormal = groundedNormal2;
                            }
                        }
                    }
                }
            }

            Vector3 offsetVec = Vector3.zero;

            bool validationState = isValidForAdaptingRotationToSurfaceSlope();

            if (validationState != m_prevValidationState || m_updateTargetRotationContinously)
            {
                if (validationState && groundedResult.isGrounded)
                {
                    if (m_alignmentAlgorithm == AlignmentAlgorithm.SIMPLE_SURFACE_NORMAL)
                    {
                        m_targetRotation = Quaternion.FromToRotation(m_transform.up, groundedResult.groundedNormal);
                    }
                    else
                    {
                        Vector3 right = Vector3.Cross(groundedResult.groundedNormal, m_transform.up);
                        Vector3 up = Vector3.Cross(right, groundedResult.groundedNormal);
                        Vector3 projForwardVecOnLeft = Vector3.Project(m_transform.forward, right);
                        Vector3 projForwardVecOnDown = Vector3.Project(m_transform.forward, up);
                        Vector3 projForwardVec = projForwardVecOnLeft + projForwardVecOnDown;
                        m_targetRotation = Quaternion.FromToRotation(m_transform.forward, projForwardVec.normalized);
                    }

                    Vector3 distToGroundedPointVec = groundedResult.groundedPoint - m_transform.position;
                    offsetVec = Vector3.Project(distToGroundedPointVec, groundedResult.groundedNormal);
                    offsetVec += m_positionalHeightOffset * groundedResult.groundedNormal;
                }
                else
                {
                    m_targetRotation = Quaternion.identity;
                }

                m_prevValidationState = validationState;
            }

            m_surfaceDeltaRot = Quaternion.Slerp(m_surfaceDeltaRot, m_targetRotation, Time.deltaTime * m_adaptRotationToSurfaceSlopeTransitionSpeed);
            m_currOffsetVec = Vector3.Lerp(m_currOffsetVec, offsetVec, Time.deltaTime * m_positionOffsetTransitionSpeed);

            Vector3 distVec = m_animator.bodyPosition - m_transform.position;
            m_animator.bodyPosition = m_transform.position + m_surfaceDeltaRot * distVec + m_currOffsetVec;
            m_animator.bodyRotation = m_surfaceDeltaRot * m_animator.bodyRotation;
        }

        /* protected virtual bool isValidForAdaptingRotationToSurfaceSlope()
        {
            if (m_forceAdaptRotationToSurfaceSlope != m_prevForceAdaptRotation)
            {
                if (m_forceAdaptRotationToSurfaceSlope) m_IKlegfoot.setIsValidAndShouldCheckForGrounded(IKLegFoot.ValidationType.FORCE_INVALID);
                else m_IKlegfoot.setIsValidAndShouldCheckForGrounded(IKLegFoot.ValidationType.CHECK_IS_GROUNDED);

                m_prevForceAdaptRotation = m_forceAdaptRotationToSurfaceSlope;
            }

            if (m_forceAdaptRotationToSurfaceSlope) return true;

            foreach (var entry in m_adaptRotationToSurfaceSlopeAnimStates)
            {
                if (m_animator.layerCount > entry.Key)
                {
                    var nextAnimState = m_animator.GetNextAnimatorStateInfo(entry.Key);
                    if (nextAnimState.shortNameHash == entry.Value && nextAnimState.normalizedTime > 0) return true;

                    bool hasStartedTransitionToAnotherState = nextAnimState.shortNameHash != entry.Value && nextAnimState.normalizedTime > 0;
                    if (hasStartedTransitionToAnotherState == false && m_animator.GetCurrentAnimatorStateInfo(entry.Key).shortNameHash == entry.Value) return true;
                }
            }

            return false;
        } */

        // Raycast

        protected virtual bool getHitPoint(CustomGroundDetectionCast cast, Vector3 upVec, out RaycastHit hit)
        {
            float raycastUpwardsOffset = cast.radius + cast.distance;
            float raycastDistance = raycastUpwardsOffset + cast.distance - cast.radius;
            Vector3 origin = cast.targetTransform.position + upVec * raycastUpwardsOffset;
            Ray ray = new Ray(origin, -upVec);
            if (Physics.SphereCast(ray, cast.radius, out hit, raycastDistance, m_IKlegfoot.collisionLayerMask, m_IKlegfoot.triggerCollisionInteraction)) return true;
            return false;
        }
    }
}