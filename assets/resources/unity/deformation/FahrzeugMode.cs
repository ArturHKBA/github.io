using UnityEngine;
using NaughtyAttributes;
//using NaughtyAttributes;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace FahrzeugMode
{
	[AddComponentMenu("")]
	public class modeBase : MonoBehaviour
	{
		
		[BoxGroup("Reference")]
		public modeBase referenceFahrzeug;

		internal bool hasReference => referenceFahrzeug != null; 
		
		[Range(0f, 2f), BoxGroup("Runtime Settings")]
		public float pressure = .5f;

		/// <summary>
		/// Die Werte
		/// </summary>
		[Range(0.2f, .8f), OnValueChanged("SetMinRadius"), BoxGroup("Design time Settings"), HideIf("hasReference")]
		public float minRadiusNormalized = .65f;
		
		protected float maxRadius;

		protected Vector3 fahrzeugPosition = Vector3.zero;
		protected Quaternion fahrzeugRotation = Quaternion.identity;
		
		// Fürs Tracking

		protected float lastFahrzeugRadius = 0;
		
		void SetMinRadius()
		{
			minRadius = maxRadius * minRadiusNormalized;
		}

		private void Awake()
		{
			if(referenceFahrzeug)
				CopyFromReference();
		}

		private void CopyFromReference()
		{
			pressure = referenceFahrzeug.pressure;
			minRadiusNormalized = referenceFahrzeug.minRadiusNormalized;
		}

		protected void SetFahrzeugData(Vector3 position, Quaternion rotation)
		{
			fahrzeugPosition = position;
			fahrzeugRotation = rotation;
		}
#if UNITY_EDITOR
		public virtual void OnDrawGizmosSelected()
		{
			var lastCol = Handles.color;
			
			Handles.color = Color.purple;

			/*
			
			Vector3 fahrzeugPosition = Vector3.zero;
			Quaternion fahrzeugRotation = Quaternion.identity;
			fahrzeugCollider.GetWorldPose (out fahrzeugPosition, out fahrzeugRotation);

			*/
			
			Handles.DrawWireDisc(fahrzeugPosition, transform.right, minRadius);
			
			// Label

			GUIStyle centeredStyle = new GUIStyle("label");
			centeredStyle.alignment = TextAnchor.MiddleCenter;
			
			var lastGUIColor = GUI.color;
			GUI.color = Color.purple;
			Handles.Label(fahrzeugPosition, "Radius", centeredStyle);

			GUI.color = lastGUIColor;
			Handles.color = lastCol;
		}
#endif
	}
}