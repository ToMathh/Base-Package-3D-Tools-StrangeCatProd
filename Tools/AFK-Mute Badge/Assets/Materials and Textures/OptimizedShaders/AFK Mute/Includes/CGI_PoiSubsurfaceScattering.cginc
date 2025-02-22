#ifndef SUBSURFACE
    #define SUBSURFACE
    /*
    float _SSSThickness;
    half4 _SSSColor;
    float _SSSPointLightDirectionality;
    float _SSSNormalOffset;
    float _SSSStrength;
    float _SSSExponent;
    float _SSSNDotL;
    float _SSSConstant;
    
    #if defined(PROP_SSSTHICKNESSMAP) || !defined(OPTIMIZER_ENABLED)
        POI_TEXTURE_NOSAMPLER(_SSSThicknessMap);
    #endif
    
    half3 calculateSubsurfaceScattering(const float4 albedo)
    {
        #if defined(PROP_SSSTHICKNESSMAP) || !defined(OPTIMIZER_ENABLED)
            float thicknessMap = 1 - POI2D_SAMPLER_PAN(_SSSThicknessMap, _MainTex, poiMesh.uv[float(0)], float4(0,0,0,0));
        #else
            float thicknessMap = 1;
        #endif
        
        half4 translucencyColor = float4(1,0.06731268,0.09007461,1);
        float3 lightDir = poiLight.direction;
        
        #ifdef FORWARD_BASE_PASS
            half tLitDot = saturate(dot((poiLight.direction + poiMesh.normals[1] * _SSSNormalOffset), -poiCam.viewDir));
        #else
            float3 lightDirectional = normalize(_WorldSpaceLightPos0.xyz - poiCam.worldPos);
            lightDir = normalize(lerp(poiLight.direction, lightDirectional, _SSSPointLightDirectionality));
            half tLitDot = saturate(dot((poiLight.direction + poiMesh.normals[1] * _SSSNormalOffset), -poiCam.viewDir));
        #endif
        
        tLitDot = exp2(-_SSSExponent * (1 - tLitDot)) * _SSSStrength;
        float NDotL = abs(dot(poiLight.direction, poiMesh.normals[1]));
        tLitDot *= lerp(1, NDotL, _SSSNDotL);
        
        half translucencyOcclusion = lerp(1, thicknessMap, _SSSThickness);
        half translucencyAtten = (tLitDot + _SSSConstant * (NDotL + 0.1)) * translucencyOcclusion;
        
        return translucencyAtten * albedo.rgb * translucencyColor.rgb * poiLight.lightMap * poiLight.color;
    }
    */
    
    float _SSSThicknessMod;
    float _SSSSCale;
    float _SSSPower;
    float _SSSDistortion;
    float4 _SSSColor;
    float _EnableSSS;
    
    #if defined(PROP_SSSTHICKNESSMAP) || !defined(OPTIMIZER_ENABLED)
        POI_TEXTURE_NOSAMPLER(_SSSThicknessMap);
    #endif
    
    float3 calculateSubsurfaceScattering()
    {
        #if defined(PROP_SSSTHICKNESSMAP) || !defined(OPTIMIZER_ENABLED)
            float SSS = 1 - POI2D_SAMPLER_PAN(_SSSThicknessMap, _MainTex, poiMesh.uv[float(0)], float4(0,0,0,0));
        #else
            float SSS = 1;
        #endif
        half3 vLTLight = poiLight.direction + poiMesh.normals[0] * float(1);
        half flTDot = pow(saturate(dot(poiCam.viewDir, -vLTLight)), float(5)) * float(0.25);
        #ifdef FORWARD_BASE_PASS
            half3 fLT = (flTDot) * saturate(SSS + - 1 * float(0));
        #else
            half3 fLT = poiLight.attenuation * (flTDot) * saturate(SSS + - 1 * float(0));
        #endif
        
        return fLT * poiLight.color * float4(1,0.06731268,0.09007461,1) * poiLight.attenuation;
    }
#endif
