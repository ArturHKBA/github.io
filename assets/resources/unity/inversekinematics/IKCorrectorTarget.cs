using UnityEngine;

namespace IKCorrectorTarget
{
    public class IKCorrectorTarget : MonoBehaviour
    {
        [SerializeField] IKLegFoot m_IKlegfoot;
        [SerializeField] bool m_negate = true;
        [SerializeField] UpdateMode m_updateMode = UpdateMode.Update;
        [SerializeField] bool m_utilizeLocalStartOffsetToParent = false;
        [SerializeField] bool m_resetToLocalStartPositionWhenDisabled = false;
        [SerializeField] bool m_resetToLocalStartPositionWhenIKLegFootIsDisabled = false;
        [SerializeField] OffsetMethod m_offsetMethod = OffsetMethod.FULLBODY_OFFSET;

        public enum OffsetMethod
        {
            FULLBODY_OFFSET,
            RIGHT_HAND_OFFSET,
            RIGHT_SHOULDER_OFFSET,
            LEFT_HAND_OFFSET,
            LEFT_SHOULDER_OFFSET
        }

        public enum UpdateMode
        {
            Update,
            FixedUpdate,
            LateUpdate,
            ManualUpdate
        }

        Transform m_transform;
        Transform m_parentTransform;
        Vector3 m_localOffset;

        void Awake()
        {
            m_transform = this.transform;
            m_parentTransform = m_transform.parent;
        }

        private void OnDisable()
        {
            if (m_resetToLocalStartPositionWhenDisabled) m_transform.localPosition = m_localOffset;
        }

        void Start()
        {
            m_localOffset = m_transform.localPosition;
        }

        void Update()
        {
            if (m_updateMode == UpdateMode.Update) updateCorrection();
        }

        private void FixedUpdate()
        {
            if (m_updateMode == UpdateMode.FixedUpdate) updateCorrection();
        }

        private void LateUpdate()
        {
            if (m_updateMode == UpdateMode.LateUpdate) updateCorrection();
        }

        public void updateCorrection()
        {
            if (m_IKlegfoot == null) return;
            if (m_IKlegfoot.enabled == false && m_resetToLocalStartPositionWhenIKLegFootIsDisabled)
            {
                m_transform.localPosition = m_localOffset;
                return;
            }

            Vector3 offset = m_IKlegfoot.fullBodyOffset;

            if (m_offsetMethod == OffsetMethod.RIGHT_HAND_OFFSET)
            {
                offset = m_IKlegfoot.getRightHandOffsetVecIncludingLeaning();
            }
            else if(m_offsetMethod == OffsetMethod.RIGHT_SHOULDER_OFFSET)
            {
                offset = m_IKlegfoot.getRightShoulderOffsetVecIncludingLeaning();
            }
            else if (m_offsetMethod == OffsetMethod.LEFT_HAND_OFFSET)
            {
                offset = m_IKlegfoot.getLeftHandOffsetVecIncludingLeaning();
            }
            else if (m_offsetMethod == OffsetMethod.LEFT_SHOULDER_OFFSET)
            {
                offset = m_IKlegfoot.getLeftShoulderOffsetVecIncludingLeaning();
            }

            if (m_negate) offset *= -2;

            if (m_utilizeLocalStartOffsetToParent == false) m_transform.position = m_parentTransform.position + offset;
            else m_transform.position = m_parentTransform.position + m_localOffset + offset;
        }
    }
}