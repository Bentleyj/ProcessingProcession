using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScaleController : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        float width = Screen.width;
        float height = Screen.height;

        if(width < height)
        {
            //Fit to Width

        }
        if(height < width)
        {
            // Fit to Height
        }

	}
}
