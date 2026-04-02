using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class FPS : MonoBehaviour
{
    [SerializeField] float UpdateTime = 0.3f;
    Mein3DText = Text;

    int FpsCount = 0;
    float Timer = 0;

    private int currentFps;
    private int totalFps;
    private int totalUpdates;

    void Start()
    {
        Text = GetComponent<TextMeshProUGUI>();
        Text.color = Color.red;
    }

    void LateUpdate()
    {
        if (Timer >= UpdateTime)
        {
            Text.text = (FpsCount / Timer).ConvertTo<int>().ToString();
            currentFps = (FpsCount / Timer).ConvertTo<int>();
            totalFps = totalFps + currentFps;
            totalUpdates++;
            Timer = 0;
            FpsCount = 0;
        }
        else
        {
            Timer += Time.deltaTime;
            FpsCount++;
        }
    }
    private void OnApplicationQuit()
    {
        if (totalUpdates > 1)
        {
            int final = totalFps / (totalUpdates - 1);
            Debug.Log("Deine FPS:"" = " + final);
        }
    }
}
