using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class MeshGenerator : MonoBehaviour
{

    

    public Mesh GeneratePlane(int length)
    {

        //Create lists of vertices, normals and uvs
        int numVertices = (length) * (length);
        int numIndices = length * length * 6;
        Vector3[] vertices = new Vector3[numVertices];
        Vector3[] normals = new Vector3[numVertices];
        Vector2[] UVs = new Vector2[numVertices];
        int[] indices = new int[numIndices];
        int T_index = 0;

        //create vertices,normals,uvs 
        for (int x = 0; x < length; x++)
        {
            for (int y = 0; y < length; y++)
            {
                Vector3 vertex = new Vector3(x, 0.0f, y);
                Vector3 normal = new Vector3(0.0f, 1.0f, 0.0f);
                Vector2 uv = new Vector2((float)x / (float)(length-1), (float)y / (float)(length-1));
                vertices[x + y * length] = vertex;
                normals[x + y * length] = normal;
                UVs[x + y * length] = uv;
            }

        }
        //create indices for  each triangle in a quad
        for (int x = 0; x < length - 1; x++)
        {
            for (int y = 0; y < length - 1; y++)
            {
                //Each corner of a quad
                int i0 = x + y * length;
                int i1 = x + (y + 1) * length;
                int i2 = (x + 1) + y * length;

                int i3 = (x+1) + (y + 1) * length;
                //First triangle
                indices[T_index++] = i0;
                indices[T_index++] = i1;
                indices[T_index++] = i2;
                //Second triangle
                indices[T_index++] = i1;
                indices[T_index++] = i3;
                indices[T_index++] = i2;


            }
        }

        
        // Create a new mesh and the generated properties
        Mesh plane = new Mesh();
        plane.vertices = vertices;
        plane.uv = UVs;
        plane.triangles = indices;
        plane.normals = normals;

        return plane;
    }


}

