#include "sg.h"
#include <math.h>
#include <stdio.h>
#include <TCHAR.h>
#include <iostream>
#include <fstream>

template<typename swapType>
void SwapValues(swapType& A, swapType& B)
{
	swapType C = A;
	A = B;
	B = C;    
}

// Returns "true" if parameters are equal (with accuracy)
bool CompareValues(sgFloat A, sgFloat B)
{
	return (abs(A-B) <= 0.00000001);	
}

int DrawCount=0;

void CALLBACK DoDraw(LPCADDATA Data, LPARAM Param)
{
	OSVERSIONINFOEX osvi;
	DWORDLONG dwlConditionMask = 0;
	ZeroMemory(&osvi, sizeof(OSVERSIONINFOEX));
	osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);
	osvi.dwPlatformId = VER_PLATFORM_WIN32_NT;
	VER_SET_CONDITION(dwlConditionMask, VER_PLATFORMID, VER_EQUAL);	

	HBRUSH PreviousBrush, brush;
	HPEN PreviousPen, pen;
	int i;

	HDC hDC = LPPARAM(Param)->hDC;
	POINT *Pts, offset = LPPARAM(Param)->offset;
	double Scale = LPPARAM(Param)->Scale;
       

	pen = CreatePen(0, (int)Data->Thickness, Data->Color);
	PreviousPen = (HPEN)SelectObject(hDC, pen);

	

	switch (Data->Tag)
	{
		case CAD_ACIS:
		{
			//ACIS data as a ANSI string is Data->CADExtendedData->AnsiStr
			//ACIS data as a UNICIDE string is Data->Text
		}	
		break;
		case CAD_LINE:
		{
			float thickness = 0;
			if (Data->CADExtendedData != NULL)
			{     
				/* IMPORTANT  
				   Data->CADExtendedData->Param1 - is a LPVOID type but 
				   the value for CAD_LINE must be read as float,
				   i.e. LPVOID four bytes are a 32-bit float value
				*/
				memcpy(&thickness, &(Data->CADExtendedData->Param1), 4);			
			}
			switch(LPPARAM(Param)->DrawMode)
			{
				case 0:
					for (i = 0; i <= Data->DashDotsCount - 1; i += 2)
					{
						if ((Data->DashDots[i].x == Data->DashDots[i+1].x) && 
							(Data->DashDots[i].y == Data->DashDots[i+1].y))
							sgSetPixel(hDC, GetPoint(Data->DashDots[i], offset, Scale), Data->Color);
						else
						{
							sgMoveTo(hDC, GetPoint(Data->DashDots[i], offset, Scale));
							sgLineTo(hDC, GetPoint(Data->DashDots[i+1], offset, Scale));
						}
					}
					break;
				case 1:
					HPEN hPen, hOldPen;
										
					hPen = (HPEN)CreatePen(Data->Style,1,Data->Color);
					hOldPen = (HPEN)SelectObject(hDC, hPen);
					sgMoveTo(hDC, GetPoint(Data->Point1, offset, Scale));
					sgLineTo(hDC, GetPoint(Data->Point2, offset, Scale));
					SelectObject(hDC, hOldPen);
					DeleteObject(hPen);
					break;
				case 2:
					if (Data->Count == 0)
					{
						sgMoveTo(hDC, GetPoint(Data->Point1, offset, Scale));
					    sgLineTo(hDC, GetPoint(Data->Point2, offset, Scale));
					}
					else
                    {   // For LINE with Thickness (DXF-code 39)
						sgMoveTo(hDC, GetPoint(Data->DATA.PolyPoints[0], offset, Scale));
					    for(i = 1; i < Data->Count; i++)
                            sgLineTo(hDC, GetPoint(Data->DATA.PolyPoints[i], offset, Scale));
                    }					
					break;
			}
		}
		break;		
        
		// Definition of beginning VIEWPORT
		case CAD_BEGIN_VIEWPORT:
            {
                // Creates a clipping region according to the VIEWPORT's boundary.
                // Makes necessary actions before drawing the VIEWPORT and his "contents".
				POINT pt;
				POINT *vPoly = NULL;
				RECT R;
			    HRGN Rgn, MainRgn;			    
				SaveDC(hDC);
                HPEN hPen = (HPEN)CreatePen(PS_SOLID,1,Data->Color);
				SelectObject(hDC, hPen);
				pt = GetPoint(Data->Point1, offset, Scale);
				R.left = pt.x;
				R.top = pt.y;
                pt = GetPoint(Data->Point2, offset, Scale);
				R.right = pt.x;
				R.bottom = pt.y;				
				if (R.left > R.right) SwapValues(R.left, R.right);
				if (R.top > R.bottom) SwapValues(R.top, R.bottom);                
				if (Data->Count == 0)
				{
					MainRgn = CreateRectRgnIndirect(&R);
					if ((Data->Flags && 1) != 0)
						::Rectangle(hDC, R.left, R.top, R.right, R.bottom);	
				}
                else
				{
					MainRgn = CreateRectRgn(0, 0, 0, 0);					
                    for(int I = 0, K = 0, PolyCount = 0; I <Data->Count; I++)
                    {						
                        /* IMPORTANT  
					    Data->DATA.PolyPoints[I].X - is a
					    float type but the value must be read as integer 
					    (count of points in the current VIEWPORT boundary),
					    i.e. float four bytes is a 32-bit integer value
					    */
					    memcpy(&PolyCount, &(Data->DATA.PolyPoints[K].x), 4);
						K++;
                        if (vPoly != NULL)
							delete vPoly;
						vPoly = new POINT[PolyCount];
                        for (int J=0; J < PolyCount; J++)
                            vPoly[J] = GetPoint(Data->DATA.PolyPoints[J+K], offset, Scale);
						Rgn = CreatePolygonRgn(vPoly, PolyCount, ALTERNATE);
                        CombineRgn(MainRgn, MainRgn, Rgn, RGN_XOR);
                        DeleteObject(Rgn);
						K+= PolyCount;
					}
				}// end of else
                if (vPoly != NULL)
                    delete vPoly;
				pt.x = 0;
				pt.y = 0;
                LPtoDP(hDC, &pt, 1);
                OffsetRgn(MainRgn, pt.x, pt.y);
                SelectClipRgn(hDC, MainRgn);
				DeleteObject(hPen);
                DeleteObject(MainRgn);
                break;
			}
        // Definition of ending VIEWPORT
        case CAD_END_VIEWPORT:
            {
                RestoreDC(hDC, -1);
				break;
            }

		// Definition of beginning and ending inserts
	    case CAD_BEGIN_INSERT:
            {
				((LPPARAM)(Param))->IsInsideInsert = (int *)1;
				//char str[100];
				//sprintf(str, "INSERT '%s' began!!!", Data->Text);
                //MessageBox(0, (LPCTSTR)str, "Beginning INSERT message", 0);
                // insert data structure sets BEGIN of 'INSERT enumeration'
                // the next element will be any entity in current insert
                break;
            }
        case CAD_END_INSERT:
            {
				((LPPARAM)(Param))->IsInsideInsert = (int *)0;
				//char str[100];
				//sprintf(str, "INSERT '%s' ended!!!", Data->Text);
                //MessageBox(0, (LPCTSTR)str, "Ending INSERT message", 0);
				// insert data structure sets END of 'INSERT enumeration' 
                // the next element will be entity not in current insert
				break;
            }

		// The code below executes only if  CADProhibitCurvesAsPoly(hCAD, 0) is called
	    case CAD_BEGIN_POLYLINE:
            {                
                //MessageBox(0, (LPCTSTR)"POLILINE began!!!", "Beginning POLYLINE message", 0); 
                // 'blank' structure sets BEGIN of 'POLYLINE enumeration' 
                // the next element will be ARC or LINE 
                break;
            }
        case CAD_END_POLYLINE:
            {
                //MessageBox(0, (LPCTSTR)"POLILINE ended!!!", "Ending POLYLINE message", 0);
				// 'blank' structure sets END of 'POLYLINE enumeration'
				break;
            }

		case CAD_POLYLINE:
		case CAD_LWPOLYLINE:
			switch(LPPARAM(Param)->DrawMode)
			{
			// Draw using DashDots
			case 0:
				//  If polyline is dotted or dash-dotted
				if (Data->CADExtendedData->IsDotted)
                {
                    for (i = 0; i <= Data->DashDotsCount - 1; i += 2)
                    {
                       if ((Data->DashDots[i].x == Data->DashDots[i+1].x) &&
                           (Data->DashDots[i].y == Data->DashDots[i+1].y))
                           sgSetPixel(hDC, GetPoint(Data->DashDots[i], offset, Scale), Data->Color);
                       else
                       {
                           sgMoveTo(hDC, GetPoint(Data->DashDots[i], offset, Scale));
                           sgLineTo(hDC, GetPoint(Data->DashDots[i+1], offset, Scale));
                       }
                    }
                }
				// If polyline is solid
				else
				{					
                    if (Data->Count > 0)
                    {
						sgMoveTo(hDC, GetPoint(Data->DATA.PolyPoints[0], offset, Scale));
					    for (i = 1; i < Data->Count; i++)
                            sgLineTo(hDC, GetPoint(Data->DATA.PolyPoints[i], offset, Scale));
                    }
				}
				break;
			// Draw using WinAPI
			case 1:
				if (Data->Count > 0)
				{
                    HPEN hPen, hOldPen;				
					hPen = (HPEN)CreatePen(Data->Style, 1, Data->Color);
					hOldPen = (HPEN)SelectObject(hDC, hPen);				
					sgMoveTo(hDC, GetPoint(Data->DATA.PolyPoints[0], offset, Scale));
					for (i = 1; i < Data->Count ; i++)				
						sgLineTo(hDC, GetPoint(Data->DATA.PolyPoints[i], offset, Scale));				
					SelectObject(hDC, hOldPen);
					DeleteObject(hPen);
				}
				break;
			// Draw as solid lines
			case 2:
				if (Data->Count > 0)
				{
					sgMoveTo(hDC, GetPoint(Data->DATA.PolyPoints[0], offset, Scale));
					for(i = 1; i < Data->Count ; i++)				
						sgLineTo(hDC, GetPoint(Data->DATA.PolyPoints[i], offset, Scale));
				}
				break;
			}
			break;

		case CAD_SPLINE:
			
			int count, j;
			if (Data->CADExtendedData->IsDotted)
			{
				count = Data->DashDotsCount - 1;
				j = 2;
			}
			else
			{
				count = Data->DashDotsCount - 2;
				j = 1;
			}
            for (i = 0; i <= count; i += j)
            {
               if ((Data->DashDots[i].x == Data->DashDots[i+1].x) && (Data->DashDots[i].y == Data->DashDots[i+1].y))
                   sgSetPixel(hDC, GetPoint(Data->DashDots[i], offset, Scale), Data->Color);
               else
               {
                   sgMoveTo(hDC, GetPoint(Data->DashDots[i], offset, Scale));
                   sgLineTo(hDC, GetPoint(Data->DashDots[i+1], offset, Scale));
               }
            }
			break;

		case CAD_SOLID: 
	    case CAD_3DFACE:
  			brush = CreateSolidBrush(Data->Color);
			PreviousBrush = (HBRUSH)SelectObject(hDC, brush);
			Pts = new POINT [4];
			Pts[0] = GetPoint(Data->Point1, offset, Scale);
			Pts[1] = GetPoint(Data->Point2, offset, Scale);
			Pts[3] = GetPoint(Data->Point3, offset, Scale);
			Pts[2] = GetPoint(Data->Point4, offset, Scale);

							sgMoveTo(hDC, Pts[0]);
							sgLineTo(hDC, Pts[1]);
							sgLineTo(hDC, Pts[2]);
							sgLineTo(hDC, Pts[3]);
							sgLineTo(hDC, Pts[1]);


			//Polygon(hDC, Pts, 4);
			delete [] Pts;



			SelectObject(hDC, PreviousBrush);
			DeleteObject(brush);
			break;
/*
	    case CAD_3DFACE:
      	    brush = CreateSolidBrush(Data->Color);
	        PreviousBrush = (HBRUSH)SelectObject(hDC, brush);  
            Pts = new POINT [2];
            if (Data->Flags & 1 == 0)
            {    
              Pts[0] = GetPoint(Data->Point1, offset, Scale);
    	      Pts[1] = GetPoint(Data->Point2, offset, Scale);
           	  Polygon(hDC, Pts, 2);
            }
            if (Data->Flags & 2 == 0)
            {    
              Pts[0] = GetPoint(Data->Point2, offset, Scale);
	          Pts[1] = GetPoint(Data->Point3, offset, Scale);
	          Polygon(hDC, Pts, 2);
            }
            if (Data->Flags & 4 == 0)
            {    
              Pts[0] = GetPoint(Data->Point3, offset, Scale);
	          Pts[1] = GetPoint(Data->Point4, offset, Scale);
	          Polygon(hDC, Pts, 2);
            }
            if (Data->Flags & 8 == 0)
            {
              Pts[0] = GetPoint(Data->Point4, offset, Scale);
	          Pts[1] = GetPoint(Data->Point1, offset, Scale);    
	          Polygon(hDC, Pts, 2);
            }  
            delete [] Pts;
            SelectObject(hDC, PreviousBrush);
            DeleteObject(brush);
            break;
*/
		case CAD_CIRCLE:	
		case CAD_ARC:
		case CAD_ELLIPSE:	
		{
			if (VerifyVersionInfo(&osvi, VER_PLATFORMID, dwlConditionMask))
			  SetArcDirection(hDC, AD_COUNTERCLOCKWISE);					
			POINT nPt, nPt1;
			FPOINT dxfPoint;			
			long double MajorLength;
			double Ratio = Data->DATA.Arc.Ratio;
			RECT mRect;			
            HPEN hPen = (HPEN)CreatePen(Data->Style,1,Data->Color);
			HPEN hOldPen = (HPEN)SelectObject(hDC, hPen);
			brush = HBRUSH(GetStockObject(NULL_BRUSH));
			PreviousBrush = (HBRUSH)SelectObject(hDC, brush);
			Pts = new POINT [4];

			if (LPPARAM(Param)->GetArcsCurves)
			{
				if (Data->DATA.Arc.EntityType == 1)
				{
					nPt = GetPoint(Data->Point1, offset, Scale);
					dxfPoint.x = Data->Point1.x + Data->Point2.x;
					dxfPoint.y = Data->Point1.y + Data->Point2.y;
					dxfPoint.z = 0;
					nPt1 = GetPoint(dxfPoint, offset, Scale);							
					Pts[2] = GetPoint(Data->Point3, offset, Scale);
					Pts[3] = GetPoint(Data->Point4, offset, Scale);
					MajorLength = sqrt(pow((nPt1.x - nPt.x), 2.0) + pow((nPt1.y - nPt.y), 2.0));					
					mRect.left = long(ceill(nPt.x - MajorLength));
					mRect.right = long(ceill(nPt.x + MajorLength));
					mRect.bottom = long(ceill(nPt.y + MajorLength * Ratio));
					mRect.top = long(ceill(nPt.y - MajorLength * Ratio));														
					if (mRect.right < mRect.left)
						SwapValues(mRect.bottom, mRect.top);
					if (mRect.bottom < mRect.top)
						SwapValues(mRect.bottom, mRect.top);					
				}
			}

			switch(LPPARAM(Param)->CircleDrawMode) 
			{            
			case 0:								
				if (LPPARAM(Param)->GetArcsCurves)
				{				
					if (Data->DATA.Arc.EntityType == 1)
					{					
						if (((Data->Point3.x != Data->Point4.x) || 
							(Data->Point3.y != Data->Point4.y)) &&
							(Pts[2].x == Pts[3].x) && (Pts[2].y == Pts[3].y))
							SetPixelV(hDC, Pts[2].x, Pts[2].y, Data->Color);
						else
                            Arc(hDC, mRect.left, mRect.top, mRect.right, mRect.bottom, 
								Pts[2].x, Pts[2].y, Pts[3].x, Pts[3].y);
					}
					else
					{
						Pts[0] = GetPoint(Data->Point1, offset, Scale);
						Pts[1] = GetPoint(Data->Point2, offset, Scale);
						Pts[2] = GetPoint(Data->Point3, offset, Scale);
						Pts[3] = GetPoint(Data->Point4, offset, Scale);
						if ((!CompareValues(Data->Point3.x, Data->Point4.x) || 
							!CompareValues(Data->Point3.y, Data->Point4.y)) &&
							(Pts[2].x == Pts[3].x) && (Pts[2].y == Pts[3].y))
							SetPixelV(hDC, Pts[2].x, Pts[2].y, Data->Color);
						else
							Arc(hDC, Pts[0].x, Pts[1].y, Pts[1].x, Pts[0].y, 
								Pts[2].x, Pts[2].y, Pts[3].x, Pts[3].y);
					}
				}
				else
				{
					int j;
					if (Data->CADExtendedData->IsDotted)
						j = 2;
					else
						j = 1;
					for (i = 0; i <= Data->DashDotsCount - 2; i += j)
					{
						if ((Data->DashDots[i].x == Data->DashDots[i+1].x) && (Data->DashDots[i].y == Data->DashDots[i+1].y))
							sgSetPixel(hDC, GetPoint(Data->DashDots[i], offset, Scale), Data->Color);
						else
						{
							sgMoveTo(hDC, GetPoint(Data->DashDots[i], offset, Scale));
							sgLineTo(hDC, GetPoint(Data->DashDots[i+1], offset, Scale));
						}
					}
				}
				break;
			case 1:				
				if (LPPARAM(Param)->GetArcsCurves)
				{					
					if (Data->DATA.Arc.EntityType == 1)
					{					
                        if ((!CompareValues(Data->Point3.x, Data->Point4.x) || 
							!CompareValues(Data->Point3.y, Data->Point4.y)) &&
							(Pts[2].x == Pts[3].x) && (Pts[2].y == Pts[3].y))						
							SetPixelV(hDC, Pts[2].x, Pts[2].y, Data->Color);							
						else
                            Arc(hDC, mRect.left, mRect.top, mRect.right, mRect.bottom, 
								Pts[2].x, Pts[2].y, Pts[3].x, Pts[3].y);
					}
					else
					{
						Pts[0] = GetPoint(Data->Point1, offset, Scale);
						Pts[1] = GetPoint(Data->Point2, offset, Scale);
						Pts[2] = GetPoint(Data->Point3, offset, Scale);
						Pts[3] = GetPoint(Data->Point4, offset, Scale);
						if ((!CompareValues(Data->Point3.x, Data->Point4.x) || 
							!CompareValues(Data->Point3.y, Data->Point4.y)) &&
							(Pts[2].x == Pts[3].x) && (Pts[2].y == Pts[3].y))
                            SetPixelV(hDC, Pts[2].x, Pts[2].y, Data->Color);
						else
							Arc(hDC, Pts[0].x, Pts[1].y, Pts[1].x, Pts[0].y, 
								Pts[2].x, Pts[2].y, Pts[3].x, Pts[3].y);
					}
				}
				else
				{
					Pts[0] = GetPoint(Data->Point1, offset, Scale);
					Pts[1] = GetPoint(Data->Point2, offset, Scale);
					Pts[2] = GetPoint(Data->Point3, offset, Scale);
					Pts[3] = GetPoint(Data->Point4, offset, Scale);
					if ((!CompareValues(Data->Point3.x, Data->Point4.x) || 
						!CompareValues(Data->Point3.y, Data->Point4.y)) &&
						(Pts[2].x == Pts[3].x) && (Pts[2].y == Pts[3].y))					
						SetPixelV(hDC, Pts[2].x, Pts[2].y, Data->Color);
					else
					{
						if (Data->DATA.Arc.StartAngle == Data->DATA.Arc.EndAngle)
								SetPixelV(hDC, Pts[2].x, Pts[2].y, Data->Color);
							else
						Arc(hDC, Pts[0].x, Pts[1].y, Pts[1].x, Pts[0].y, 
							Pts[2].x, Pts[2].y, Pts[3].x, Pts[3].y);					
					}
		
				}
				break;
			case 2:
				if (LPPARAM(Param)->GetArcsCurves)
				{
					if (Data->DATA.Arc.EntityType == 1)
					{						
						if ((!CompareValues(Data->Point3.x, Data->Point4.x) || 
							!CompareValues(Data->Point3.y, Data->Point4.y)) &&
							(Pts[2].x == Pts[3].x) && (Pts[2].y == Pts[3].y))
							SetPixelV(hDC, Pts[2].x, Pts[2].y, Data->Color);							
						else
                            Arc(hDC, mRect.left, mRect.top, mRect.right, mRect.bottom, 
								Pts[2].x, Pts[2].y, Pts[3].x, Pts[3].y);
					}
					else
					{
						Pts[0] = GetPoint(Data->Point1, offset, Scale);
						Pts[1] = GetPoint(Data->Point2, offset, Scale);
						Pts[2] = GetPoint(Data->Point3, offset, Scale);
						Pts[3] = GetPoint(Data->Point4, offset, Scale);
						if ((!CompareValues(Data->Point3.x, Data->Point4.x) || 
							!CompareValues(Data->Point3.y, Data->Point4.y)) &&
							(Pts[2].x == Pts[3].x) && (Pts[2].y == Pts[3].y))
							SetPixelV(hDC, Pts[2].x, Pts[2].y, Data->Color);
						else
							Arc(hDC, Pts[0].x, Pts[1].y, Pts[1].x, Pts[0].y, 
                                Pts[2].x, Pts[2].y, Pts[3].x, Pts[3].y);						
					}
				}				
				else
				{
					Pts[0] = GetPoint(Data->Point1, offset, Scale);
					Pts[1] = GetPoint(Data->Point2, offset, Scale);
					Pts[2] = GetPoint(Data->Point3, offset, Scale);
					Pts[3] = GetPoint(Data->Point4, offset, Scale);
					if ((!CompareValues(Data->Point3.x, Data->Point4.x) || 
						!CompareValues(Data->Point3.y, Data->Point4.y)) &&
						(Pts[2].x == Pts[3].x) && (Pts[2].y == Pts[3].y))
						SetPixelV(hDC, Pts[2].x, Pts[2].y, Data->Color);
					else
						Arc(hDC, Pts[0].x, Pts[1].y, Pts[1].x, Pts[0].y, 
							Pts[2].x, Pts[2].y, Pts[3].x, Pts[3].y);					
				}
				break;	
			default:				
				break;	
			}
			
			delete [] Pts;
			SelectObject(hDC, hOldPen);
			DeleteObject(hPen);
			SelectObject(hDC, PreviousBrush);
			DeleteObject(brush);
			break;
		}// end of CAD_ELLIPSE
		case CAD_TEXT:
		case CAD_ATTDEF:
		case CAD_ATTRIB: 
		{
			/*
			PsgChar attdef_tag = NULL;
			if ((Data->CADExtendedData != NULL) && ((Data->Tag==CAD_ATTDEF) || (Data->Tag==CAD_ATTRIB)))
			{
				// IMPORTANT
				//	 Data->CADExtendedData->Param1 - is a LPVOID type but the
				//	 value for CAD_ATTDEF and CAD_ATTRIB must be read as PsgChar,
				//	 i.e. LPVOID four bytes are a 32-bit PsgChar value
				//
				attdef_tag = (PsgChar)Data->CADExtendedData->Param1;
			}
			*/
			if ((LPPARAM(Param)->GetTextsCurves) && (Data->DashDotsCount > 0))
			{				
				int i, j, k, Cnt, PolyCount;				
				int *Counts;
				Counts = new int[Data->DashDotsCount];
				// Counts calculation				
                for(i = 0, k = 0, PolyCount = 0; i < Data->DashDotsCount; i++)
                {						
                    /* IMPORTANT  
					Data->DashDots[k].x - is a float type but the value 
					must be read as integer (count of points in the current boundary),
					i.e. float four bytes is a 32-bit integer value
					*/
					memcpy(&PolyCount, &(Data->DashDots[k].x), 4);
					Counts[i] = PolyCount;
					k += PolyCount+1;
				}
				// Points creation
				Pts = new POINT[k - Data->DashDotsCount];
                for(i = 0, k = 0, PolyCount = 0; i < Data->DashDotsCount; i++)
                {						
                    /* IMPORTANT  
					Data->DashDots[k].x - see above...
					*/
					memcpy(&PolyCount, &(Data->DashDots[k].x), 4);
					k++;
                    for (j=0; j < PolyCount; j++)
                        Pts[j+k-1-i] = GetPoint(Data->DashDots[j+k], offset, Scale);
					k += PolyCount;					
				}				
				if ((Data->Flags & 1) != 0)
				{
					// SHX text					
					for(i = 0, k = 0; i < Data->DashDotsCount; i++)
					{
						Cnt = Counts[i];
						if ((Cnt == 2) && (Pts[k].x == Pts[k+1].x) && (Pts[k].y == Pts[k+1].y))
							SetPixelV(hDC, Pts[k].x, Pts[k].y, Data->Color);
						else
							Polyline(hDC, &Pts[k], Cnt);
						k += Cnt;
			        } 					
			    }
				else
				{
					// TTF text
					brush = CreateSolidBrush(Data->Color);
			        PreviousBrush = (HBRUSH)SelectObject(hDC, brush);
					PolyPolygon(hDC, Pts, Counts, Data->DashDotsCount);
					SelectObject(hDC, PreviousBrush);
			        DeleteObject(brush);
				}                
				delete [] Counts;
				delete [] Pts;				
			}
			else
			{
				HFONT PreviousFont, font;
				LOGFONT logfont;
	//			if (!Data->Text)
	//			{ 
	//					SelectObject(hDC, PreviousPen);
	//					DeleteObject(pen);
	//					return;
	//			}

				Pts = new POINT; 			
				if (!(Data->DATA.Text.HAlign || Data->DATA.Text.VAlign))
					*Pts = GetPoint(Data->Point1, offset, Scale);
				else 
					*Pts = GetPoint(Data->Point2, offset, Scale);
				memset(&logfont, 0, sizeof(logfont));
				logfont.lfHeight = (LONG)(1.6 * Data->DATA.Text.FHeight * Scale);			
				logfont.lfWidth = (LONG)(0.64 * Data->DATA.Text.FHeight * Scale *
					Data->DATA.Text.FScale);
				if (logfont.lfWidth == 0)
					logfont.lfWidth = 1;
				if (!Data->DATA.Text.FHeight || (logfont.lfHeight == 0)) 
					logfont.lfHeight = 1;		
				logfont.lfOrientation = logfont.lfEscapement;
				logfont.lfCharSet = DEFAULT_CHARSET;
				logfont.lfClipPrecision = CLIP_DEFAULT_PRECIS;
				logfont.lfEscapement = (LONG)Data->Rotation * 10;
				logfont.lfItalic = 0;			
				logfont.lfOutPrecision = OUT_DEFAULT_PRECIS;
				logfont.lfPitchAndFamily = DEFAULT_PITCH;
				logfont.lfQuality = DEFAULT_QUALITY;
				logfont.lfStrikeOut = 0;
				logfont.lfWeight = FW_DONTCARE;			
				logfont.lfUnderline = 0;	
				PTCHAR fontname = sgCharToTCHAR(Data->FontName);
				memcpy((void *)logfont.lfFaceName, (const void *)fontname, sizeof(logfont.lfFaceName));
				free(fontname);
				font = CreateFontIndirect(&logfont);
	//			DWORD err;
	//			err = 0;
	//			if (font == NULL)
	//			{
	//				CHAR szBuf[80]; 
	//				DWORD dw;
	//				dw = GetLastError();  
	//				sprintf(szBuf, "%s failed: GetLastError returned %u\n", 
	//					"CreateFontIndirect", dw);  
					//MessageBox(NULL, szBuf, "Error", MB_OK);     				
	//			}

				PreviousFont = (HFONT)SelectObject(hDC, font);
		
				SetTextAlign(hDC, TA_BASELINE);
				SetTextColor(hDC, Data->Color);
				SetBkMode(hDC, TRANSPARENT);
				PTCHAR text = sgCharToTCHAR(Data->Text);
				TextOut(hDC, Pts->x, Pts->y, text, _tcslen(text));
				free(text);
				SelectObject(hDC, PreviousFont);
				DeleteObject(font);
				delete Pts;
			}
			
		}
		break;

		case CAD_POINT:
			sgSetPixel(hDC, GetPoint(Data->Point1, offset, Scale), Data->Color);
			break;

		case CAD_HATCH:			
			POINT *vPoly; 
			vPoly = NULL;
			HRGN vRGN, vMainRGN;
			int I, J, K, SaveIndex, Index, PolyCount;

            if (Data->Flags == 16)            // hatch is SOLID
			{
			  brush = CreateSolidBrush(Data->Color);
			  PreviousBrush = (HBRUSH)SelectObject(hDC, brush);
			  SaveIndex = SaveDC(hDC);

			  vMainRGN = CreateRectRgn(0, 0, 0, 0);
			  Index = 0;// this is a counter of points for each boundary
			  I = 0;    // this is a counter of boundaries themselves
			  K = 0;    // DATA.PolyPoints index
			  while (I <= Data->Count)
			  {
				  if (Index == 0)
				  {						
					  if (I!= 0)
					  {							
						  vRGN = CreatePolygonRgn(vPoly, PolyCount, ALTERNATE);	
						  CombineRgn(vMainRGN, vRGN, vMainRGN,  RGN_XOR);						  
						  DeleteObject(vRGN);
						  delete []vPoly;
						  vPoly = NULL;
						  if (I == Data->Count)
							  break;
					  }					
					  //  IMPORTANT  
					  // if I == Index then Data->DATA.PolyPoints[I].X - is a
					  // float type but the value must be read as integer 
					  // (count of points in the current hatch boundary),
					  // i.e. float four bytes are a 32-bit integer value					  
					  memcpy(&PolyCount, &(Data->DATA.PolyPoints[K].x), 4);
					  Index = PolyCount;
					  I++;
					  J = 0;
				  	  vPoly = new POINT[PolyCount];
				  }
				  else				
				  {						  
					  vPoly[J] = GetPoint(Data->DATA.PolyPoints[K], offset, Scale);					  
					  J++;
					  Index--;
				  }		
				  K++;
			  }
						
			  FillRgn(hDC, vMainRGN, brush);
			  DeleteObject(vMainRGN);
			  RestoreDC(hDC, SaveIndex);	
			  SelectObject(hDC, PreviousBrush);
			  DeleteObject(brush);
	  		  break;
			}

			PolyCount = Data->DashDotsCount;
			if (PolyCount > 0)
			{
				DWORD* vPolyCounts;
				POINT pt1, pt2;
				if (vPoly != NULL)
					delete []vPoly;
				vPoly = new POINT[PolyCount];
				vPolyCounts = new DWORD[PolyCount>>1];
				for(I = 0, J = 0, K = 0; I <= PolyCount-1; I+= 2, J+=2, K++)
				{
					pt1 = GetPoint(Data->DashDots[I], offset, Scale);
					pt2 = GetPoint(Data->DashDots[I+1], offset, Scale);
					//  sgMoveTo(hDC, pt1);
					//  sgLineTo(hDC, pt2);
					if ((pt1.x == pt2.x) && (pt1.y == pt2.y))
						pt1.x++;// for PolyPolyline
					vPoly[J] = pt1;
					vPoly[J+1] = pt2;
					vPolyCounts[K] = 2;
				}
				PolyPolyline(hDC, vPoly, vPolyCounts, PolyCount>>1/*==K*/);
			}
			break;// end of the hatch drawing

		case CAD_IMAGE_ENT:

			if ((Data->Ticks != NULL) && (Data->Handle > 0))
			{
				HBITMAP hBmp;
				HDC hCompatibleDC;
				POINT Pt, Pt1;
				int bltMode;
	
				int BmpWidth, BmpHeight, w, h;
				int NumColor;
								
				Pt = GetPoint(Data->Point2, offset, Scale);
				Pt1 = GetPoint(Data->Point3, offset, Scale);
			    if (Pt.x < Pt1.x)
                    SwapValues(Pt.x, Pt1.x);  
				if (Pt.y < Pt1.y)
					SwapValues(Pt.y, Pt1.y);
				w = Pt.x - Pt1.x;
				h = Pt.y - Pt1.y;
				void *P = (void *)((INT_PTR)Data->Ticks + sizeof(BITMAPFILEHEADER));
				
				BITMAPINFO *BitmapInfo;
				BitmapInfo = (BITMAPINFO *) malloc(sizeof(BITMAPINFOHEADER) + 256 * sizeof(RGBQUAD));
				memcpy(&BitmapInfo->bmiHeader, P, sizeof(BITMAPINFOHEADER));
				P = (void *)((INT_PTR)P + sizeof(BITMAPINFOHEADER));
				NumColor = BitmapInfo->bmiHeader.biClrUsed;
				if (!NumColor)
				{
				    NumColor = BitmapInfo->bmiHeader.biBitCount;
				    if (NumColor > 8) NumColor = 0;
				    else NumColor = 1 << NumColor;
				}
				void * Colors = (void *)((INT_PTR)BitmapInfo + BitmapInfo->bmiHeader.biSize);			
				memcpy(Colors, P, NumColor * sizeof(RGBQUAD));
				P = (void *)((INT_PTR)P + NumColor * sizeof(RGBQUAD));
				BmpWidth = BitmapInfo->bmiHeader.biWidth;
				BmpHeight = BitmapInfo->bmiHeader.biHeight;
				if (BmpHeight < 0) BmpHeight = -BmpHeight;

				void *BitsMem = NULL;
				hBmp = CreateDIBSection(hDC, BitmapInfo, DIB_RGB_COLORS, &BitsMem, 0, 0);
				NumColor = BmpHeight * (((BmpWidth * BitmapInfo->bmiHeader.biBitCount + 31)& -32) >> 3);

				memcpy(BitsMem, P, NumColor);

				free(BitmapInfo);			
				hCompatibleDC = CreateCompatibleDC(hDC);			
			
				HGDIOBJ OldObject = SelectObject(hCompatibleDC, hBmp);

				bltMode = GetStretchBltMode(hDC);

				if (VerifyVersionInfo(&osvi, VER_PLATFORMID, dwlConditionMask))
					SetStretchBltMode(hDC,HALFTONE);
				else
					SetStretchBltMode(hDC,COLORONCOLOR);
				
				StretchBlt(hDC, Pt1.x, Pt1.y, w, h, hCompatibleDC,
                   0,0,BmpWidth,BmpHeight,SRCCOPY);
//				StretchBlt(hDC, Pt.x, Pt1.y, -w, h, hCompatibleDC,
//                   0,0,BmpWidth,BmpHeight,SRCCOPY);
				SetStretchBltMode(hDC,bltMode);
				SelectObject(hCompatibleDC, OldObject);
				DeleteObject(hBmp);				
				DeleteDC(hCompatibleDC);
			}
			else
				break;
	}
	SelectObject(hDC, PreviousPen);
	DeleteObject(pen);
}


void CALLBACK GetLayerFromData(LPCADDATA Data, LPARAM Param)
{	
	if (Data->Layer)
	{
		PTCHAR layer = sgCharToTCHAR(Data->Layer);
		if (_tcscmp(layer, LPLAYER(Param)->Name) == 0)
			LPLAYER(Param)->Count++; 
		free(layer);
	}
}
