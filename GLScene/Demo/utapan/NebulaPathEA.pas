unit NebulaPathEA;

interface

var

  // for the demo
  startersx : integer;
  startersy : integer;
  endersx : integer;
  endersy : integer;
  mousex,mousey:integer;
  //
  mapwidth : integer;
  mapheight : integer;
  cellwidth : integer;
  cellheight : integer;
  startx: integer;
  starty: integer;
  //--------------------
  trender : array[1..1000,1..1000] of integer;

  //--------------------

	walkabilityEA : array[0..200+1,0..200+1] of integer; //;array that holds wall/obstacle information
	openList : array[0..(200*200)+2] of integer;//;array holding open list items
	listArray : array[0..200+1,0..200+1] of integer;//  ;array used to record
	openX : array[0..200*200+2] of integer;// ;stores the x location of an item on the open list
	openY : array[0..200*200+2] of integer;// ;stores the y location of an item on the open list
	parentX : array[0..200+1,0..200+1] of integer;// ;array to store parent of each cell (x)
	parentY : array[0..200+1,0..200+1] of integer;//;array to store parent of each cell (y)
	Fcost : array[0..201*201] of integer;	 //	;array to store F cost for each cell.
	 Gcost: array [0..200+1,0..200+1] of integer; // 	;array to store G cost for each cell.
	 Hcost: array [0..200*200+2] of integer; //		;array to store H cost for each cell.
	 pathLengthEA: array[0..1] of integer; //      ;length of the found path
	 pathLocation: array[0..1] of integer; //    ;current position along the chosen path
	 patharray: array [0..101*101] of integer; //
	pathStatus: array[0..1+1] of integer; //
	xPath: array [0..1] of integer; //
	yPath: array [0..1] of integer; //
	tempWalkability: array [0..200+2,0..200+2] of integer; //

	adjacentArea: array [0..10] of integer; //

  	Const onOpenList : integer = 1;
  Const onClosedList : integer = 2; //;listArray constants
	Const notfinished : integer = 0;
  Const notStarted : integer = 0;// path-related constants
	Const found : integer = 1;
  Const nonexistent : integer = 2;
	Const walkable : integer = 0;
  const unwalkable : integer = 1; //;walkability array constants

	const deadEnd : integer = 10;

  procedure initFindEA;
  procedure drawmapEA(width:integer;height:integer);
  procedure drawmapblockEA(x:integer;y:integer;width:integer;height:integer;value:integer);

  Function findPathEA(mapWidth:integer;mapHeight:integer;startingX:integer;startingY:integer;targetX:integer;targetY:integer):integer;
  Function readPathX2EA(pathfinderID:integer;pathLocation:integer):integer;
  Function readPathY2EA(pathfinderID:integer;pathLocation:integer):integer;

implementation
  procedure initFindEA;
  begin
  {mapwidth := 100;
  mapheight := 100;
  cellwidth := 320 div mapwidth;
  cellheight := 250 div mapheight; }

    mapwidth := 200;
    mapheight := 200;
    cellwidth := 1;//320 div mapwidth;
    cellheight := 1;//250 div mapheight;
  end; // init
  //////////////////////////////////////////////////////////////////////
  // Demo procedure
  procedure drawmapEA(width:integer;height:integer);
  
  begin
  {
  //form1.canvas.Brush.color := rgb(25,25,25);
  //form1.canvas.FillRect(bounds((0),(0),(form1.width),(form1.height)));

  for x1:=0 to 100 do begin;
  for y1:=0 to 100 do begin;
    if (walkability[x1,y1]=1) then begin
    //--------------------
     form1.canvas.Brush.color := clBlue;
     form1.canvas.FillRect(bounds((x1*cellwidth)-1,(y1*cellwidth)-1,(cellwidth)+1,(cellwidth)+1));
    //--------------------

      form1.canvas.Brush.color := rgb(100,100,100);
      form1.canvas.FillRect(bounds((x1*cellwidth),(y1*cellwidth),(cellwidth),(cellwidth)));
    end;


  end;
end;

    Form1.Memo1.Lines.Clear;

    for i:=0 to pathlength[0]-1 do
    begin
    //form1.canvas.Brush.color := rgb(0,0,200);
    form1.canvas.Brush.color := clYellow;
    x1 := readpathx2(0,i);
    y1 := readpathy2(0,i);
    //----------------- to memo
    Form1.Memo1.Lines.Add('<x:y> ' + IntToStr(x1) +
    ' : ' + IntToStr(y1));
    //-----------------
    form1.canvas.FillRect(bounds((x1*cellwidth),(y1*cellwidth),(cellwidth),(cellwidth)));
    end;
      }
end;  // draw map

// Demo procedure
procedure drawmapblockEA(x:integer;y:integer;width:integer;height:integer;value:integer);
var
x1,y1:integer;
begin
for x1:=x to x+width do
begin
  for y1:=y to y+height do
  begin
    walkabilityEA[x1,y1] := value;
  end;
end;
//
end;


Function readPathX2EA(pathfinderID:integer;pathLocation:integer):integer;
var
x:integer;
begin
  x:=0;
	If pathLocation <= pathLengthEA[pathfinderID] Then
  begin
	x := patharray[pathlocation*2+10]
	End;
	readpathx2EA := x;
End;


Function readPathY2EA(pathfinderID:integer;pathLocation:integer):integer;
var
y : integer;
begin
  y:=0;
	If pathLocation <= pathLengthEA[pathfinderID] Then
  begin
	y := patharray[pathlocation*2+11]
	End;
	readpathy2EA := y;
End;

Function findPathEA(mapWidth:integer;mapHeight:integer;startingX:integer;startingY:integer;targetX:integer;targetY:integer):integer;
var
x1,y1,x,openlistitems,parentxval,parentyval,u,v : integer;
temp,b,a,corner,squaresChecked,m,addedGCost,tempGcost : integer;
path,pathx,pathy,tempx,tempy,cellposition2 : integer;
never,pathfinderID : integer;
label nopath;
begin

for x1:= 0 to 200*200 do begin
  openlist[x1] :=0;
  fcost[x1] := 0;
end;

for x1:=0 to 201 do begin
  for y1:=0 to 201 do begin
    parentx[x1,y1] := 0;
    parenty[x1,y1] := 0;
    patharray[x1] := 0;
    tempwalkability[x1,y1] := 0;
    listarray[x1,y1] := 0;
  end;
end;

corner:=0;
squareschecked:=0;
//m:=0;
addedgcost:=0;
tempGcost:=0;
path:=0;
never:=0;
tempx:=0;
tempy:=0;
cellposition2:=0;
x:=0;
pathfinderid := 0;

for x1 := 0 to 100*100+2 do begin
  openx[x1] := 0;
  openy[x1] := 0;
end;





	startX := startingX;
  startY := startingY;
	targetX := targetX;
  targetY := targetY;
	If (startX = targetX) And (startY = targetY) And (pathLocation[pathfinderID] > 0) Then begin
  Result:= found;
  exit;
  end;
	If (startX = targetX) And (startY = targetY) And (pathLocation[pathfinderID] = 0) Then begin
  Result := nonexistent;
  exit;
  end;
	If walkabilityEA[targetX,targetY] = unwalkable Then Goto noPath;
	pathLengthEA[pathfinderID] := notstarted ;//i.e, := 0
	pathLocation[pathfinderID] := notstarted ;//i.e, := 0
	openListItems := 1;
	openList[1] := 1;
  openlist[2] := 0;
	openX[1] := startX;
  openY[1] := startY;

	Repeat
		If openListItems <> 0 Then
    begin
			parentXval := openX[openList[1]];
      parentYVal := openY[openList[1]] ;//record cell coordinates
			listArray[parentXval,parentYVal] := onClosedList ;//add cell to closed list
			openListItems := openListItems - 1 ;//reduce number of open list items by 1
			openList[1] := openList[openListItems+1] ;//put last item in slot #1
			v := 1;
			Repeat
				u := v;
				If 2*u+1 <= openListItems then//if both children exist
        begin
					If Fcost[openList[u]] >= Fcost[openList[2*u]] Then v := 2*u;
					If Fcost[openList[v]] >= Fcost[openList[2*u+1]] Then v := 2*u+1;
        end
				Else
        begin
					If 2*u <= openListItems then//if only child #1 exists
          begin
						If Fcost[openList[u]] >= Fcost[openList[2*u]] Then v := 2*u
					end;
				end;
				;//
				If u<>v then //if parent's F is > one of its children, swap them
        begin
					temp := openList[u];
					openList[u] := openList[v];
					openList[v] := temp;
        end
				Else
        begin
					//Exit ;//if item >:= both children, exit loop
          break;
				end;
			Until never = 5;//v=-100;//debug

			For b := parentYVal-1 to parentYVal+1 do begin;
				For a := parentXval-1 to parentXval+1 do begin;

					If (a <> -1) And (b <> -1) And (a <> mapWidth) And (b <> mapHeight) then
          begin
						If listArray[a,b] <> onClosedList then begin
							If walkabilityEA[a,b] <> unwalkable then begin
								If (walkabilityEA[a,b] <> deadend) then begin
									corner := walkable;

									If a = parentXVal-1 then
                  begin
                       If b = parentYVal-1 then
                       begin
											      If (walkabilityEA[parentXval-1,parentYval] = unwalkable) Or (walkabilityEA[parentXval,parentYval-1] = unwalkable) Then corner := unwalkable
                       end
                       Else if (b = parentYVal+1) then
                       begin
											      If (walkabilityEA[parentXval,parentYval+1] = unwalkable) Or (walkabilityEA[parentXval-1,parentYval] = unwalkable) Then corner := unwalkable
                       end
                  end
									Else If (a = parentXVal+1) then
                  begin
                       If b = parentYVal-1 then
                       begin
											      If (walkabilityEA[parentXval,parentYval-1] = unwalkable) Or (walkabilityEA[parentXval+1,parentYval] = unwalkable) Then corner := unwalkable
                       end
                       Else If b = parentYVal+1 then
                       begin
											      If (walkabilityEA[parentXval+1,parentYval] = unwalkable) Or (walkabilityEA[parentXval,parentYval+1] = unwalkable) Then corner := unwalkable
                       end
									end;

									If corner = walkable then
                  begin
										If listArray[a,b] <> onOpenList then
                    begin
											squaresChecked := squaresChecked + 1;
											m := openListItems+1 ;//m := new item at end of heap
											openList[m] := squaresChecked;
											openX[openList[m]] := a;
                      openY[openList[m]] := b;
											If (Abs(a-parentXval) = 1) And (Abs(b-parentYVal) = 1) Then
                      begin
												addedGCost := 14 //cost of going to diagonal tiles
                      end Else begin
												addedGCost := 10 //cost of going to non-diagonal tiles
											end;
											Gcost[a,b] := Gcost[parentXval,parentYVal]+addedGCost;
											Hcost[openList[m]] := 10*(Abs(a - targetx) + Abs(b - targety));
											Fcost[openList[m]] := Gcost[a,b] + Hcost[openList[m]];
											parentX[a,b] := parentXval;
                      parentY[a,b] := parentYVal;
											While m <> 1 do //While item hasn't bubbled to the top [m:=1]
                      begin
												;//Check if child is < parent. If so, swap them.
												If Fcost[openList[m]] <= Fcost[openList[m div 2]] Then
                        begin
													temp := openList[m div 2];
													openList[m div 2] := openList[m];
													openList[m] := temp;
													m := m div 2;
                        end	Else begin
													break;
												end;
											end;
											openListItems := openListItems+1 ;//add one to number of items in the heap
											listArray[a,b] := onOpenList;
                    end
										Else // If listArray[a,b] := onOpenList
                    begin
											If (Abs(a-parentXval) = 1) And (Abs(b-parentYVal) = 1) Then
                      begin
												addedGCost := 14;//cost of going to diagonal tiles
                      end
											Else
                      begin
												addedGCost := 10 //cost of going to non-diagonal tiles
											end;
											tempGcost := Gcost[parentXval,parentYVal]+addedGCost;

											If tempGcost < Gcost[a,b] Then 	//if G cost is less,
                      begin
												parentX[a,b] := parentXval 	;//change the square's parent
												parentY[a,b] := parentYVal;
												Gcost[a,b] := tempGcost 		;//change the G cost
												If listArray[a,b] = onOpenList then
                        begin
													For x := 1 To openListItems do
                          begin
													 	If (openX[openList[x]] = a) And (openY[openList[x]] = b) Then ;//item found
                            begin
															FCost[openList[x]] := Gcost[a,b] + HCost[openList[x]];
															m := x;

															While m <> 1 do;//While item hasn't bubbled to the top [m:=1]
                              begin
																If Fcost[openList[m]] < Fcost[openList[m div 2]] Then
                                begin
																	temp := openList[m div 2];
																	openList[m div 2] := openList[m];
																	openList[m] := temp;
																	m := m div 2; // Not used accorirding to compiler
                                  end Else begin
																	break; //while/wend
                                end;
															end;
                              break ;//for x := loop
                            end; //If openX[openList[x]] := a
													end ;//For x := 1 To openListItems
												end; ;//If listArray[a,b] := onOpenList
											end; ;//If tempGcost < Gcost[a,b] Then
										end; ;//If not already on the open list
									end; ;//If corner := walkable
								end; ;//If walkability[a,b] <> deadend
							end; ;//If not a wall/obstacle cell.
						end; ;//If not already on the closed list
					end; ;//If not off the map.
				end;
			end;
    //end;
    end Else begin
	    path := nonExistent;
      break;
    end;
		If listArray[targetx,targety] = onOpenList Then begin
      path := found;
      break;
    end;
  Until never = 5; //path = found ;//debug me repeat until path is found or deemed nonexistent


	If path = found Then
  begin
		pathX := targetX;
    pathY := targetY;
		Repeat
			tempx := parentX[pathX,pathY];
			pathY := parentY[pathX,pathY];
			pathX := tempx;
			pathLengthEA[pathfinderID] := pathLengthEA[pathfinderID] + 1;
		Until ((pathX = startX) And (pathY = startY));
		pathX := targetX;
    pathY := targetY;
		//cellPosition := pathlength[pathfinderID]*4+10 ;//start at the end
		cellposition2 := pathlengthEA[pathfinderID]*2+10;
		Repeat
			cellposition2 := cellposition2 - 2;
			patharray[cellposition2] := pathx;
			patharray[cellposition2+1] := pathy;
			tempx := parentX[pathX,pathY];
			pathY := parentY[pathX,pathY];
			pathX := tempx;
		Until (pathX = startX) And (pathY = startY);
	end; ;//If path := found Then

	findpathEA := path;//path;// Returns 1 if a path has been found, 2 if no path exists.
  exit;
	noPath:
	xPath[pathfinderID] := startingX;
	yPath[pathfinderID] := startingY;

  Result := nonexistent;

end;


procedure processMHCollision();

begin
  initFindEA;
end;

  //////////////////////////////////////////////////////////////////////
end.

 