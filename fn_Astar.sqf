//TODO: _allForks -> ....

params ["_startRoute","_goalRoute"];
// создаем ассоциотивный массив на основе ХТ.
private _htCreat = {
params [["_name","temp",[""]]];
	_loc = createLocation ["fakeTown",[0,0,0],0,0];
	_loc setName _name;
	_loc
};
//Сэт нодов
private _htSet = {
	params ["_namespace","_key","_val"];
	_namespace setVariable [_key,_val];
};
private _htFind = {
	params ["_namespace","_key"];
	_namespace getVariable _key
};
private _htExist = {!isNil {_this call _htFind}};
private _pqInsert = { 
	params ["_queue","_element","_priority"];

	_queue pushBack [_priority,_element];
	_queue sort true;
};
private _pqGet = {
	params ["_queue"];

	(_queue deleteAt 0) select 1;};
private _allForks = parseSimpleArray (missionConfigFile >> "optima_forks" >> "Altis");
private _frontier = [];
private _came_from = [] call _htCreat;
private _cost_so_far = [] call _htCreat;

[_came_from,str road(_startRoute),objNull] call _htSet;
[_frontier,_startRoute,0] call _pqInsert;
[_cost_so_far,str road(_startRoute),0] call _htSet;

while {count _frontier > 0} do {
	// получаем нод с минимальным значением в очереди
	private _current = [_frontier] call _pqGet;

	if (_current isEqualTo _goalRoute) exitWith {};

	{
		_x params ["_next","_cost"];
		_new_cost = ([_cost_so_far,str road(_current)] call _htFind) + _cost;

		if (
			!([_cost_so_far,str road(_next)] call _htExist) 
		) then {
			[_cost_so_far,str road(_next),_new_cost] call _htSet;
			_priority = _new_cost + (_goalRoute distance _next);
			[_frontier,_next,_priority] call _pqInsert;
			[_came_from,str road(_next),_current] call _htSet;
		}else{
			if (_new_cost < ([_cost_so_far,str road(_next)] call _htFind)) then {
				[_cost_so_far,str road(_next),_new_cost] call _htSet;
				_priority = _new_cost + (_goalRoute distance _next);
				[_frontier,_next,_priority] call _pqInsert;
				[_came_from,str road(_next),_current] call _htSet;
			};
		};

	}foreach ([_allForks,str road(_current)] call _htFind);
};

_came_from