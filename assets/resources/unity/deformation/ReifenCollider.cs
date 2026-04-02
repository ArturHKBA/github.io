using UnityEngine;
//using NaughtyAttributes; // Wird durch FahrzeugMode nicht mehr Benötigt
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace ReifenCollider
{
	[RequireComponent(typeof(ReifenCollider))]
	public class ReifenCollider : FahrzeugReifenMain, FahrzeugMode
	{
		private ReifenCollider reifenCollider;

		public void Init()
		{
			if(reifenCollider == null)
				reifenCollider = GetComponent<ReifenCollider>();
			maxRadius = reifenCollider.radius;
			minRadius = maxRadius * minRadiusNormalized;
		}

		private void Start()
		{
			wh = new ReifenHit();
			Init();
		}


		private void FixedUpdate()
		{
			compression = GetReifenCompression();
			reifenCollider.radius = Mathf.Lerp(maxRadius, minRadius, Mathf.Clamp01(compression + (1-pressure)));
		}

		public void SetReifenPressure(float normalizedPressure)
		{
			pressure = normalizedPressure;
		}

		public float GetReifenCompression()
		{
			float targetDistance = reifenCollider.suspensionDistance;

			/* 
			
			_springCompression = -reifenCollider.transform.InverseTransformPoint(GetGroundHitPoint()).y - reifenCollider.radius;


			_springCompression = Mathf.Clamp(_springCompression, 0, targetDistance);

			// Funktioniert nicht

			_springCompression /= targetDistance * reifenCollider.suspensionSpring.targetPosition + Mathf.Epsilon;
			*/

			float _springCompression = Vector3.Distance(reifenCollider.transform.position, GetGroundHitPoint()) - reifenCollider.radius;

			//_springCompression /= targetDistance * reifenCollider.suspensionSpring.targetPosition + Mathf.Epsilon;

			return Mathf.InverseLerp(targetDistance, 1, _springCompression);

		//	return 1 - _springCompression;

		}

		private ReifenHit wh;
		
		private Vector3 GetGroundHitPoint()
		{
			reifenCollider.GetGroundHit(out wh);
			return wh.point; 
		}
		#if UNITY_EDITOR
		public override void OnDrawGizmosSelected()
		{
			if (reifenCollider == null || !Application.isPlaying && !Mathf.Approximately(lastReifenRadius, reifenCollider.radius))
			{
				Init();
				lastReifenRadius = reifenCollider.radius;
			}

			Vector3 reifenPosition = transform.position;
			
			// Vector3.zero;

			Quaternion reifenRotation = transform.rotation;
			
			// Quaternion.identity;
			//reifenCollider.GetWorldPose (out reifenPosition, out reifenRotation);

			SetReifenData(reifenPosition, reifenRotation);
			base.OnDrawGizmosSelected();
		}
		#endif
	}	
}