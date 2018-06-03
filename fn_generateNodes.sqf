params [
	["_startRoute",objNull,[objNull]],
	["_goalRoute",objNull,[objNull]]
];

private _htFind = {
	params ["_namespace","_key"];
	_namespace getVariable _key
};
private _came_from = [_startRoute,_goalRoute] call DT_fnc_AStar;

if(_came_from isEqualTo []) then { systemChat "PATH_NOT_FOUND" };

private _current = _goalRoute;
private _path = [];

while {_current != _startRoute} do {
  _path pushBack _current;
  _current = _came_from getVariable [str _current,""];
  if (isNil "_current") then { systemChat "PATH_NOT_FOUND" };
};

_path pushBack _startRoute;
reverse _path;

_path