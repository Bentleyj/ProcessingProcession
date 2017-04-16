using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraToggle : MonoBehaviour {

    public UnityEngine.Video.VideoPlayer player;

    public MeshRenderer rend;

    public int[] frames;
    int index;

	// Use this for initialization
	void Start () {
        if (!player)
            player = FindObjectOfType<UnityEngine.Video.VideoPlayer>();
        if (!rend)
            rend = GetComponent<MeshRenderer>();

        index = 0;

        player.loopPointReached += EndReached;

        frames = new int[12];
        frames[0] = 1847;//61.56; // On
        frames[1] = 1969;//65.8; // Off
        frames[2] = 2382;//79.47; // On *
        frames[3] = 2625;// 87.67; // Off *
        frames[4] = 2767;// 92.13; // On
        frames[5] = 2928;// 97.67; // Off
        frames[6] = 3423;// 114.07; // On
        frames[7] = 3760;// 125.5; // Off
        frames[8] = 3793;// 126.4; // On
        frames[9] = 3873;// 129.23; // Off
        frames[10] = 4590;// 153.00; // On
        frames[11] = 4900;// 160.00; // Off
        //frames[12] = 4595;// 160.00; // Off
        //frames[13] = 4798;// 160.00; // Off

    }
	
	// Update is called once per frame
	void Update () {
        long frame = player.frame;
        Debug.Log(frame);
        if(frame >= frames[index])
        {
            //player.playbackSpeed = 0;
            rend.enabled = !rend.enabled;
            index++;
            if (index > frames.Length)
            {
                Loop();
            }
        }
    }

    private void OnDisable()
    {
        player.loopPointReached -= EndReached;
    }

    void EndReached(UnityEngine.Video.VideoPlayer vp)
    {
        Loop();
    }

    void Loop()
    {
        index = 0;
        rend.enabled = false;
    }

}
