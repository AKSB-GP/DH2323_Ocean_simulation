using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Main : MonoBehaviour
{
    // Start is called before the first frame update
    public int length = 32;
    public int resolution = 32;
    public MeshGenerator Mg;

    public Material Water;

    void Start()
    {

        //create a class instance planegenerator and call upon the generateplane function
        Mg = GetComponent<MeshGenerator>();
        Mesh Oceantile = Mg.GeneratePlane(length);


        //get the meshfilter and meshrenderers
        MeshRenderer renderer = GetComponent<MeshRenderer>();
        //if the renderer doesnt exist, create a new one
        if (renderer == null)
        {
            renderer = gameObject.AddComponent<MeshRenderer>();

        }
        //render the material
        renderer.material = Water;
        GetComponent<MeshFilter>().mesh = Oceantile;


    }

    
}