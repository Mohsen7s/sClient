/* (c) Magnus Auvinen. See licence.txt in the root of the distribution for more information. */
/* If you are missing that file, acquire a complete release at teeworlds.com.                */
#include <engine/shared/config.h>
#include <engine/graphics.h>
#include <engine/textrender.h>

#include <game/generated/protocol.h>
#include <game/generated/client_data.h>

#include <game/layers.h>

#include <game/client/gameclient.h>
#include <game/client/animstate.h>
#include <game/client/render.h>

//#include "controls.h"
//#include "camera.h"
#include "debughud.h"
#include "controls.h"

void CDebugHud::RenderNetCorrections()
{
	if(!g_Config.m_Debug || g_Config.m_DbgGraphs || !m_pClient->m_Snap.m_pLocalCharacter || !m_pClient->m_Snap.m_pLocalPrevCharacter)
		return;

	float Width = 300*Graphics()->ScreenAspect();
	Graphics()->MapScreen(0, 0, Width, 300);

	/*float speed = distance(vec2(netobjects.local_prev_character->x, netobjects.local_prev_character->y),
		vec2(netobjects.local_character->x, netobjects.local_character->y));*/

	float Velspeed = length(vec2(m_pClient->m_Snap.m_pLocalCharacter->m_VelX/256.0f, m_pClient->m_Snap.m_pLocalCharacter->m_VelY/256.0f))*50;
	float Ramp = VelocityRamp(Velspeed, m_pClient->m_Tuning[g_Config.m_ClDummy].m_VelrampStart, m_pClient->m_Tuning[g_Config.m_ClDummy].m_VelrampRange, m_pClient->m_Tuning[g_Config.m_ClDummy].m_VelrampCurvature);

	const char *paStrings[] = { ""
			,"velspeed:"
			,"velspeed*ramp:"
			,"ramp:"
			,"Pos"
			," x:"
			," y:"
			,"Vel"
			," (x|y)/32:"
			," (x|y):"
			,"Mouse"
			," x:"
			," y:"
			,"angle:"
			,"netobj corrections"
			," num:"
			," on:"
	};
	const int Num = sizeof(paStrings)/sizeof(char *);
	const float LineHeight = 6.0f;
	const float Fontsize = 5.0f;

	float x = Width-100.0f, y = 50.0f;
	for(int i = 0; i < Num; ++i)
		TextRender()->Text(0, x, y+i*LineHeight, Fontsize, paStrings[i], -1);

	#define PUT_STRING(FMT, ...) \
		str_format(aBuf, sizeof(aBuf), FMT, __VA_ARGS__); \
		w = TextRender()->TextWidth(0, Fontsize, aBuf, -1); \
		TextRender()->Text(0, x-w, y, Fontsize, aBuf, -1)

	#define PUT_LINEBREAK() y += LineHeight

	x = Width-10.0f;
	char aBuf[128];
	float w;
	PUT_LINEBREAK();

	PUT_STRING("%.0f", Velspeed/32);
	PUT_LINEBREAK();
	PUT_STRING("%.0f", Velspeed/32*Ramp);
	PUT_LINEBREAK();
	PUT_STRING("%.2f", Ramp);
	PUT_LINEBREAK();
	PUT_LINEBREAK();
	PUT_STRING("%.2f / %i", static_cast<float>(m_pClient->m_Snap.m_pLocalCharacter->m_X)/32.0f, m_pClient->m_Snap.m_pLocalCharacter->m_X);
	PUT_LINEBREAK();
	PUT_STRING("%.2f / %i", static_cast<float>(m_pClient->m_Snap.m_pLocalCharacter->m_Y)/32.0f, m_pClient->m_Snap.m_pLocalCharacter->m_Y);
	PUT_LINEBREAK();
	PUT_LINEBREAK();
	PUT_STRING("%.2f | %.2f", static_cast<float>(m_pClient->m_Snap.m_pLocalCharacter->m_VelX)/32.0f, static_cast<float>(m_pClient->m_Snap.m_pLocalCharacter->m_VelY)/32.0f);
	PUT_LINEBREAK();
	PUT_STRING("%i | %i", m_pClient->m_Snap.m_pLocalCharacter->m_VelX, m_pClient->m_Snap.m_pLocalCharacter->m_VelY);
	PUT_LINEBREAK();
	PUT_LINEBREAK();
	PUT_STRING("%.2f / %i", (m_pClient->m_pControls->m_MousePos[g_Config.m_ClDummy].x+m_pClient->m_Snap.m_pLocalCharacter->m_X)/32.0f, round_to_int(m_pClient->m_pControls->m_MousePos[g_Config.m_ClDummy].x+(float)m_pClient->m_Snap.m_pLocalCharacter->m_X));
	PUT_LINEBREAK();
	PUT_STRING("%.2f / %i", (m_pClient->m_pControls->m_MousePos[g_Config.m_ClDummy].y+m_pClient->m_Snap.m_pLocalCharacter->m_Y)/32.0f, round_to_int(m_pClient->m_pControls->m_MousePos[g_Config.m_ClDummy].y+(float)m_pClient->m_Snap.m_pLocalCharacter->m_Y));
	PUT_LINEBREAK();
	PUT_STRING("%d", m_pClient->m_Snap.m_pLocalCharacter->m_Angle);
	PUT_LINEBREAK();
	PUT_LINEBREAK();
	PUT_STRING("%d", m_pClient->NetobjNumCorrections());
	PUT_LINEBREAK();
	PUT_STRING("%s", m_pClient->NetobjCorrectedOn() && m_pClient->NetobjCorrectedOn()[0] ? m_pClient->NetobjCorrectedOn() : "N/V");

	#undef PUT_STRING
	#undef PUT_LINEBREAK
}

void CDebugHud::RenderTuning()
{
	// render tuning debugging
	if(!g_Config.m_DbgTuning)
		return;

	CTuningParams StandardTuning;

	Graphics()->MapScreen(0, 0, 300*Graphics()->ScreenAspect(), 300);

	float y = 27.0f;
	int Count = 0;
	for(int i = 0; i < m_pClient->m_Tuning[g_Config.m_ClDummy].Num(); i++)
	{
		char aBuf[128];
		float Current, Standard;
		m_pClient->m_Tuning[g_Config.m_ClDummy].Get(i, &Current);
		StandardTuning.Get(i, &Standard);

		if(Standard == Current)
			TextRender()->TextColor(1,1,1,1.0f);
		else
			TextRender()->TextColor(1,0.25f,0.25f,1.0f);

		float w;
		float x = 5.0f;

		str_format(aBuf, sizeof(aBuf), "%.2f", Standard);
		x += 20.0f;
		w = TextRender()->TextWidth(0, 5, aBuf, -1);
		TextRender()->Text(0x0, x-w, y+Count*6, 5, aBuf, -1);

		str_format(aBuf, sizeof(aBuf), "%.2f", Current);
		x += 20.0f;
		w = TextRender()->TextWidth(0, 5, aBuf, -1);
		TextRender()->Text(0x0, x-w, y+Count*6, 5, aBuf, -1);

		x += 5.0f;
		TextRender()->Text(0x0, x, y+Count*6, 5, m_pClient->m_Tuning[g_Config.m_ClDummy].m_apNames[i], -1);

		Count++;
	}

	y = y+Count*6;

	Graphics()->TextureSet(-1);
	Graphics()->BlendNormal();
	Graphics()->LinesBegin();
	float Height = 50.0f;
	float pv = 1;
	IGraphics::CLineItem Array[100];
	for(int i = 0; i < 100; i++)
	{
		float Speed = i/100.0f * 3000;
		float Ramp = VelocityRamp(Speed, m_pClient->m_Tuning[g_Config.m_ClDummy].m_VelrampStart, m_pClient->m_Tuning[g_Config.m_ClDummy].m_VelrampRange, m_pClient->m_Tuning[g_Config.m_ClDummy].m_VelrampCurvature);
		float RampedSpeed = (Speed * Ramp)/1000.0f;
		Array[i] = IGraphics::CLineItem((i-1)*2, y+Height-pv*Height, i*2, y+Height-RampedSpeed*Height);
		//Graphics()->LinesDraw((i-1)*2, 200, i*2, 200);
		pv = RampedSpeed;
	}
	Graphics()->LinesDraw(Array, 100);
	Graphics()->LinesEnd();
	TextRender()->TextColor(1,1,1,1);
}

void CDebugHud::OnRender()
{
	RenderTuning();
	RenderNetCorrections();
}
