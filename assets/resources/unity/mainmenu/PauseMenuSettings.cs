using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PauseMenuSettings : MonoBehaviour
{
    [SerializeField] private GameObject pauseMenuObj;
    public static bool gameIsPaused = false;
    private bool gameIsPausedLocal;

    void Start()
    {
        gameIsPausedLocal = false;
        gameIsPaused = false;

        pauseMenuObj.SetActive(false);
    }


    void Update()
    {

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            if(gameIsPausedLocal)
            {
                Resume();
            }
            else
            {
                Pause();
            }
        }


    }
    public void Resume()
    {
        gameIsPausedLocal = false;
        gameIsPaused = false;
        pauseMenuObj.SetActive(false);
        Time.timeScale = 1f;
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;

    }
    public void Pause()
    {
        gameIsPausedLocal = true;
        gameIsPaused = true;
        pauseMenuObj.SetActive(true);
        Time.timeScale = 0f;
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
    }
}
