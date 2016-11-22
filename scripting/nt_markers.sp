#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <neotokyo>

// How many seconds to display sprites for
#define TE_DURATION 30.0

// Enums for various sprites
enum {
  A,B,C,D,E,F,UNKNOWN,X,ENUM_COUNT
};

// Global sprite precache indexes
g_iModelIndex[ENUM_COUNT];

// Sprite file paths, referred to by enum
new const String:g_sModel[][] = {
  "materials/vgui/hud/cp/cp_a.vmt",     // A
  "materials/vgui/hud/cp/cp_b.vmt",     // B
  "materials/vgui/hud/cp/cp_c.vmt",     // C
  "materials/vgui/hud/cp/cp_d.vmt",     // D
  "materials/vgui/hud/cp/cp_e.vmt",     // E
  "materials/vgui/hud/cp/cp_f.vmt",     // F
  "materials/vgui/hud/cp/cp_none.vmt",  // UNKNOWN
  "materials/vgui/hud/x1.vmt"           // X
};

public Plugin myinfo = {
  name = "Neotokyo Markers",
  description = "Allow teams to draw temporary markers in the environment for coordination",
  author = "Rain",
  version = "0.1",
  url = ""
};

public void OnPluginStart()
{
  // Each of these spawns the matching sprite.
  // Commands are separated so players can bind these to their liking.
  RegConsoleCmd("sm_mark_a", Command_Mark_A);
  RegConsoleCmd("sm_mark_b", Command_Mark_B);
  RegConsoleCmd("sm_mark_c", Command_Mark_C);
  RegConsoleCmd("sm_mark_d", Command_Mark_D);
  RegConsoleCmd("sm_mark_e", Command_Mark_E);
  RegConsoleCmd("sm_mark_f", Command_Mark_F);
  RegConsoleCmd("sm_mark_unknown", Command_Mark_Unknown);
  RegConsoleCmd("sm_mark_x", Command_Mark_X);
}

// Purpose: The sprites must be precached and indexed before use
public void OnMapStart()
{
  for (int i = 0; i < ENUM_COUNT; i++)
  {
    g_iModelIndex[i] = PrecacheModel(g_sModel[i]);
    if (!g_iModelIndex[i])
    {
      SetFailState("Failed precaching model %s", g_sModel[i]);
    }
  }
}

public Action Command_Mark_A(int client, int args)
{
  DrawSymbol(client, A);
  return Plugin_Handled;
}
public Action Command_Mark_B(int client, int args)
{
  DrawSymbol(client, B);
  return Plugin_Handled;
}
public Action Command_Mark_C(int client, int args)
{
  DrawSymbol(client, C);
  return Plugin_Handled;
}
public Action Command_Mark_D(int client, int args)
{
  DrawSymbol(client, D);
  return Plugin_Handled;
}
public Action Command_Mark_E(int client, int args)
{
  DrawSymbol(client, E);
  return Plugin_Handled;
}
public Action Command_Mark_F(int client, int args)
{
  DrawSymbol(client, F);
  return Plugin_Handled;
}
public Action Command_Mark_Unknown(int client, int args)
{
  DrawSymbol(client, UNKNOWN);
  return Plugin_Handled;
}
public Action Command_Mark_X(int client, int args)
{
  DrawSymbol(client, X);
  return Plugin_Handled;
}

// Purpose: Draw a sprite at client aim position and display it to their team
void DrawSymbol(int client, int style)
{
  float eyePos[3];
  GetClientEyePosition(client, eyePos);
  float eyeAng[3];
  GetClientEyeAngles(client, eyeAng);

  Handle ray = TR_TraceRayEx(eyePos, eyeAng, MASK_VISIBLE, RayType_Infinite);

  float targetPos[3];
  TR_GetEndPosition(targetPos, ray);
  delete ray;

  TE_SetupGlowSprite(targetPos, g_iModelIndex[style], TE_DURATION, 0.5, 100);

  int team = GetClientTeam(client);
  int teamMates[MAXPLAYERS+1];
  int arrayIndex;
  for (int i = 1; i <= MaxClients; i++)
  {
    if (!IsValidClient(i) || IsFakeClient(i))
      continue;

    int teamBuffer = GetClientTeam(i);
    if (teamBuffer != team)
      continue;

    teamMates[arrayIndex++] = i;
  }

  TE_Send(teamMates, arrayIndex);
}
