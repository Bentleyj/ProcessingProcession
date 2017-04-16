using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamController : MonoBehaviour {

    public WebCamTexture webCam;

    public Material mat;

	// Use this for initialization
	void Start () {
        WebCamDevice[] devices = WebCamTexture.devices;
        for (var i = 0; i < devices.Length; i++)
            Debug.Log(devices[i].name);

        webCam = new WebCamTexture(devices[0].name);

        mat.mainTexture = webCam;

        webCam.Play();
    }
}
