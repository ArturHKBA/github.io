using UnityEngine;

namespace IKSystem
{
    [RequireComponent(typeof(Animator))]
    public class AdvancedIKLegs : MonoBehaviour
    {
        private Animator anim;

        [Header("Boden wird Erkannt")]
        public LayerMask groundLayer;

        // Abstand Füße zu Boden

        public float footOffset = 0.05f;
        //public float footOffset = 0.1f; 
        //public float footOffset = 0.25f;       

        // Die Box um den Charakter herum (Suche nach IK)
        // !!! Zu groß = Verwirrung / Zu klein = Ungenau !!!

        public float raycastRange = 1.5f;   // Balanciert 
        // public float raycastRange = 10.0f;   // Sehr sicher aber verwirrend
        // public float raycastRange = 0.5f;   // Keine Verwirrung aber instabil und Ungenau! 
        
        [Header("Gewicht und genauigkeit")]
        [Range(0, 1)] public float ikWeight = 1f;

        // Verhindert das Zittern
        // Wird ab Unity 6.1 nicht mehr Benötigt! 

        public float positionLerpSpeed = 15f;
        public float rotationLerpSpeed = 10f;

        [Header("Hüfte (Pelvis)")]
        public bool usePelvisOffset = true;
        public float pelvisLerpSpeed = 5f;
        
        private float lastPelvisOffset;
        private Vector3 leftIKLegFootPos, rightIKLegFootPos;
        private Quaternion leftIKLegFootRot, rightIKLegFootRot;
        private float lastLeftWeight, lastRightWeight;

        void Start()
        {
            anim = GetComponent<Animator>();
            leftIKLegFootRot = rightIKLegFootRot = Quaternion.identity;
        }

        // !!! Im Animator Controller (Component) MUSS "IK Pass" im Layer aktiv sein !!!

        void OnAnimatorIK(int layerIndex)
        {
            if (!anim) return;

            // Gewichte

            anim.SetIKPositionWeight(AvatarIKGoal.LeftFoot, ikWeight);
            anim.SetIKRotationWeight(AvatarIKGoal.LeftFoot, ikWeight);
            anim.SetIKPositionWeight(AvatarIKGoal.RightFoot, ikWeight);
            anim.SetIKRotationWeight(AvatarIKGoal.RightFoot, ikWeight);

            // Füße berechnen

            SolveIKLegFoot(AvatarIKGoal.LeftFoot, ref leftIKLegFootPos, ref leftIKLegFootRot);
            SolveIKLegFoot(AvatarIKGoal.RightFoot, ref rightIKLegFootPos, ref rightIKLegFootRot);

            // Hüfte anpassen (damit der Charakter in die Knie gehen kann siehe Bild 2)

            if (usePelvisOffset) 
                ApplyPelvisOffset();

            // Ergebnisse an den Animator übergeben (Siehe Bild 3)

            anim.SetIKPosition(AvatarIKGoal.LeftFoot, leftIKLegFootPos);
            anim.SetIKRotation(AvatarIKGoal.LeftFoot, leftIKLegFootRot);
            anim.SetIKPosition(AvatarIKGoal.RightFoot, rightIKLegFootPos);
            anim.SetIKRotation(AvatarIKGoal.RightFoot, rightIKLegFootRot);
        }

        private void SolveIKLegFoot(AvatarIKGoal foot, ref Vector3 lastPos, ref Quaternion lastRot)
        {
            Vector3 footPos = anim.GetIKPosition(foot);
            RaycastHit hit;

            // Weiter oben wird Raycast berechnet, um Stufen zu erkennen

            Vector3 rayStart = footPos + Vector3.up * (raycastRange * 0.5f);
            
            if (Physics.Raycast(rayStart, Vector3.down, out hit, raycastRange, groundLayer))
            {
                // Ziel wird berechnet

                Vector3 targetPos = hit.point;
                targetPos.y += footOffset;

                // Instabil

                lastPos = Vector3.Lerp(lastPos, targetPos, Time.deltaTime * positionLerpSpeed);
                
                // Füße an Terrain anpassen

                Quaternion targetRot = Quaternion.LookRotation(Vector3.ProjectOnPlane(transform.forward, hit.normal), hit.normal);
                lastRot = Quaternion.Slerp(lastRot, targetRot, Time.deltaTime * rotationLerpSpeed);
            }
            else
            {
                // Falls kein Boden unter dem Fuß ist dann fallback

                lastPos = Vector3.Lerp(lastPos, footPos, Time.deltaTime * positionLerpSpeed);
                lastRot = Quaternion.Slerp(lastRot, anim.GetIKRotation(foot), Time.deltaTime * rotationLerpSpeed);
            }
        }

        private void ApplyPelvisOffset()
        {
            // WAnimations-Soll abweichung (Für später)

            float leftOffset = leftIKLegFootPos.y - anim.GetIKPosition(AvatarIKGoal.LeftFoot).y;
            float rightOffset = rightIKLegFootPos.y - anim.GetIKPosition(AvatarIKGoal.RightFoot).y;

            // Der niedrigste Punkt bestimmt, wie weit der Körper runter muss (Instabil)

            float targetPelvisOffset = Mathf.Min(leftOffset, rightOffset);
            
            // Wenn wir auf einem Hügel stehen, ist es instabil
            // Die Beine sollen sich einknicken und nicht der ganze Körper

            if (targetPelvisOffset > 0) targetPelvisOffset /= 3f; 

            lastPelvisOffset = Mathf.Lerp(lastPelvisOffset, targetPelvisOffset, Time.deltaTime * pelvisLerpSpeed);
            
            Vector3 pelvisPos = anim.bodyPosition;
            pelvisPos.y += lastPelvisOffset;
            anim.bodyPosition = pelvisPos;
        }
    }
}
