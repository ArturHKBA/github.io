using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;

namespace Vrc.Localization
{
	/// <summary>Dieses Komponent aktualisiert <b>UI.Dropdown</b> Komponente mit localized Text.</summary>
	[ExecuteInEditMode]
	[DisallowMultipleComponent]
	[RequireComponent(typeof(Dropdown))]
	[HelpURL(VrcLocalization.HelpUrlPrefix + "VrcLocalizedDropdown")]
	[AddComponentMenu(VrcLocalization.ComponentPathPrefix + "Localized Dropdown")]
	public class VrcLocalizedDropdown : MonoBehaviour, ILocalizationHandler
	{
		[System.Serializable]
		public class Option
		{
			[VrcTranslationName]
			public string StringTranslationName;

			[VrcTranslationName]
			public string SpriteTranslationName;

			[Tooltip("If StringTranslationName couldn't be found, this text will be used")]
			public string FallbackText;

			[Tooltip("If SpriteTranslationName couldn't be found, this sprite will be used")]
			public Sprite FallbackSprite;
		}

		[SerializeField]
		private List<Option> options;

		[System.NonSerialized]
		private HashSet<VrcToken> tokens;

		public List<Option> Options
		{
			get
			{
				if (options == null)
				{
					options = new List<Option>();
				}

				return options;
			}
		}

		public void Register(VrcToken token)
		{
			if (token != null)
			{
				if (tokens == null)
				{
					tokens = new HashSet<VrcToken>();
				}

				tokens.Add(token);
			}
		}

		public void Unregister(VrcToken token)
		{
			if (tokens != null)
			{
				tokens.Remove(token);
			}
		}

		public void UnregisterAll()
		{
			if (tokens != null)
			{
				foreach (var token in tokens)
				{
					token.Unregister(this);
				}

				tokens.Clear();
			}
		}

		/// <summary>Wenn diese Funktion aufgerufen wird, wird die Komponente anhand der localization aktualisiert.</summary>
		[ContextMenu("Update Localization")]
		public void UpdateLocalization()
		{
			var dropdown = GetComponent<Dropdown>();
			var dOptions = dropdown.options;

			if (options != null)
			{
				for (var i = 0; i < options.Count; i++)
				{
					var option  = options[i];
					var dOption = default(Dropdown.OptionData);

					if (dOptions.Count == i)
					{
						dOption = new Dropdown.OptionData();

						dOptions.Add(dOption);
					}
					else
					{
						dOption = dOptions[i];
					}

					var stringTranslation = VrcLocalization.GetTranslation(option.StringTranslationName);

					// Übersetzen?
					if (stringTranslation != null && stringTranslation.Data is string)
					{
						dOption.text = VrcTranslation.FormatText((string)stringTranslation.Data, dOption.text, this);
					}
					// Fallback?
					else
					{
						dOption.text = VrcTranslation.FormatText(option.FallbackText, dOption.text, this);
					}

					var spriteTranslation = VrcLocalization.GetTranslation(option.StringTranslationName);

					// Übersetzen?
					if (spriteTranslation != null && spriteTranslation.Data is Sprite)
					{
						dOption.image = (Sprite)spriteTranslation.Data;
					}
					// Fallback?
					else
					{
						dOption.image = option.FallbackSprite;
					}
				}
			}
			else
			{
				dOptions.Clear();
			}

			dropdown.options = dOptions;
		}

		protected virtual void OnEnable()
		{
			VrcLocalization.OnLocalizationChanged += UpdateLocalization;

			UpdateLocalization();
		}

		protected virtual void OnDisable()
		{
			VrcLocalization.OnLocalizationChanged -= UpdateLocalization;

			UnregisterAll();
		}

#if UNITY_EDITOR
		protected virtual void OnValidate()
		{
			if (isActiveAndEnabled == true)
			{
				UpdateLocalization();
			}
		}
#endif
	}
}