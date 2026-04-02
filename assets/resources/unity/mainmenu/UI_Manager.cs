using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UI_Manager : MonoBehaviour
{
    [SerializeField] private GameObject OpenMenuObj;
    public static bool isMenuOpen = false;
    private PauseMenuSettings pauseMenuSettings;
    public Image MenuSettingsShowcase;

    void Start()
    {
        pauseMenuSettings = FindObjectOfType<PauseMenuSettings>();  
        isMenuOpen = false;
        OpenMenuObj.SetActive(false);
    }

    void Update()
    {
        MenuText.text = PauseMenuSettings.MenuText + "Spiel Pausiert!" + MenuText.MenuTextClose;

        // Funktioniert nicht...
        
        if (isPlayerDead)
        {
            pauseMenuSettings.Pause();
            MenuSettingsShowcase.SetActive(true);
            isPlayerDead = false;
        }
    }
}
