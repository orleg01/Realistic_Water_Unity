using UnityEngine;
using System.Collections.Generic;

[RequireComponent(typeof(MeshFilter  ))]
[RequireComponent(typeof(MeshRenderer))]
public class SeaMesh : MonoBehaviour {

    public int resX = 200;
    public int resY = 200;

	void Start ()
    {
        Mesh mesh = new Mesh();

        mesh.vertices  = getDotes();
        mesh.uv        = getUv();
        mesh.triangles = getIndexes();
        mesh.normals   = getNormals();

        GetComponent<MeshFilter>().mesh = mesh;

	}

    private Vector3[] getDotes()
    {
        List<Vector3> dotesToReturn = new List<Vector3>();

        for (int i = 0; i < resX; i++)
            for (int j = 0; j < resY; j++)
                dotesToReturn.Add(new Vector3(i , 0 , j));

        return dotesToReturn.ToArray();
    }

    private Vector2[] getUv()
    {
        List<Vector2> uvToReturn = new List<Vector2>();

        for (int i = 0; i < resX; i++)
            for (int j = 0; j < resY; j++)
                uvToReturn.Add(new Vector2((float)i / (resX - 1) , (float) j / (resY - 1)));

        return uvToReturn.ToArray();

    }

    private int[] getIndexes()
    {
        List<int> indexToReturn = new List<int>();

        for (int i = 0; i < resX - 1; i++)
        {
            for (int j = 0; j < resY - 1; j++)
            {
                indexToReturn.Add(i + (j * resX));
                indexToReturn.Add(i + (j * resX) + 1);
                indexToReturn.Add(i + ((j + 1) * resX));
                indexToReturn.Add(i + (j * resX) + 1);
                indexToReturn.Add(i + ((j + 1) * resX) + 1);
                indexToReturn.Add(i + ((j + 1) * resX));
            }
        }

        return indexToReturn.ToArray();
    }

    private Vector3[] getNormals()
    {
        Vector3[] normals = new Vector3[resX * resY];

        for (int i = 0; i < normals.Length; i++)
            normals[i] = new Vector3(0, 1, 0);

        return normals;
    }
}
