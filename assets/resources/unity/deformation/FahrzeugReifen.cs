using System.Collections;
using System.Collections.Generic;
//using NaughtyAttributes; // Wird durch FahrzeugMode nicht mehr Benötigt 
using UnityEngine;

namespace FahrzeugReifen
{
	public interface FahrzeugReifenMain
	{
		/// <summary>
		/// 
		/// </summary>
		/// <param name="normalizedPressure"></param>
		void SetPressure(float normalizedPressure);

		/// <summary>
		/// Abhängig vom collider max - min
		/// </summary>
		float GetCompression();

		void Init();
	}
}