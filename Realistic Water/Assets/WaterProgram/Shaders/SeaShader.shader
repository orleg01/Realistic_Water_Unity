Shader "Unlit/SeaShader"
{

	Properties
	{
		_heightImageOne("height1" , 2D) = "White"{}
		_heightImageTwo("height2" , 2D) = "White"{}
		_height("maxHeight" , FLOAT) = 5
		_scale("scale" , FLOAT) = 2
	}


	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 normals : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
			};

			sampler2D _heightImageOne;
			sampler2D _heightImageTwo;
			float _height;
			float _scale ;
			
			float getMyHeight(float2 cord)
			{
				float flow = _Time;
				return (tex2Dlod(_heightImageOne, float4(float2( flow,  flow) + cord, 0, 0)).y * _height) +
					   (tex2Dlod(_heightImageTwo, float4(float2(-flow, -flow) + cord, 0, 0)).y * _height);
			}

			v2f vert (appdata v)
			{
				v2f o;
				float myHeight, leftHeight, forwardHeight;

				v.uv *= _scale;
				myHeight = v.vertex.y = getMyHeight(v.uv.xy);

				leftHeight    = getMyHeight(float2(v.uv.x + 0.005f, v.uv.y)) - myHeight;
				forwardHeight = getMyHeight(float2(v.uv.x, v.uv.y + 0.005f)) - myHeight;
				o.normals = normalize(float3(-leftHeight, 1, -forwardHeight));

				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);

				return o;
			}
			


			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = 0 ;
				
				half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				half3 worldReflect = reflect(-worldViewDir, normalize(i.normals));
				half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldReflect);
				half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

				col.rgb = skyColor;

				return col;
			}

			ENDCG
		}
	}
}
