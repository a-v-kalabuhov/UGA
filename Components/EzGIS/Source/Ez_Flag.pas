{$DEFINE TESTING} { Comment for the finished program }
{$DEFINE USE_GRAPHICEX} { uncomment if you want to use GraphicEx support }
{$DEFINE USE_RICHEDIT}  { uncomment if you need RichEdit text }
{$DEFINE ER_MAPPER}   { uncomment for activating ERMAPPER www.ermapper.com }
{.$DEFINE TRIAL_VERSION} { trial version switch }
{.$DEFINE DEMO}

//{.$DEFINE ISACTIVEX}          { this switch is used to create an ActiveX/OCX }
{$DEFINE GIS_CONTROLS}          { this switch prevents compiling only for EzGIS product }
{.$DEFINE CAD_CONTROLS}          { this switch prevents compiling only for EzCAD product }

{ language used - only in some forms is used this. See also EzConsts.Pas }
{$DEFINE LANG_ENG}   // { English }
{.$DEFINE LANG_SPA}    // { Spanish }


{$DEFINE GIF_SUPPORT} { uncomment if you want to use .GIF files by Anders Melander }
{$DEFINE JPEG_SUPPORT}           { uncomment if you want to use .JPG files}

{ ==== Do not change from here ==== }
{.$DEFINE SWAPPED_FORMAT}
{$IFDEF SWAPPED_FORMAT}
  {$UNDEF LANG_ENG}
  {$DEFINE LANG_SPA}
  {$UNDEF TRIAL_VERSION}
{$ENDIF}


{$IFDEF USE_GRAPHICEX}
{.$UNDEF JPEG_SUPPORT}
{$ENDIF}

{ ==== Determination of compiler and others (do NOT change) ==== }
{$IFDEF VER100}   // Delphi 3
{$DEFINE LEVEL3}
{$DEFINE DELPHI3}
{$DEFINE DELPHI}
{$ENDIF}

{$IFDEF VER110} // C++ Builder 3
{$DEFINE LEVEL3}
{$DEFINE BCB3}
{$DEFINE BCB}
{$ENDIF}

{$IFDEF VER120} // Delphi 4
{$DEFINE LEVEL4}
{$DEFINE DELPHI4}
{$DEFINE DELPHI}
{$ENDIF}

{$IFDEF VER125} // C++ Builder 4
{$DEFINE LEVEL4}
{$DEFINE BCB4}
{$DEFINE BCB}
{$ENDIF}

{$IFDEF VER130} // Delphi 5
{$DEFINE LEVEL4}
{$DEFINE LEVEL5}
{$DEFINE DELPHI5}
{$DEFINE DELPHI}
{$ENDIF}

{$IFDEF VER135} // C++ Builder 5
{$DEFINE LEVEL4}
{$DEFINE LEVEL5}
{$DEFINE BCB5}
{$DEFINE BCB}
{$ENDIF}

{$IFDEF VER140} // Delphi 6
{$DEFINE LEVEL4}
{$DEFINE LEVEL5}
{$DEFINE LEVEL6}
{$DEFINE DELPHI6}
{$DEFINE DELPHI}
{$ENDIF}

{$IFDEF VER145} // C++ Builder 6
{$DEFINE LEVEL4}
{$DEFINE LEVEL5}
{$DEFINE LEVEL6}
{$DEFINE BCB6}
{$DEFINE BCB}
{$ENDIF}

{$IFDEF VER150} // Delphi 7
{$DEFINE LEVEL4}
{$DEFINE LEVEL5}
{$DEFINE LEVEL6}
{$DEFINE LEVEL7}
{$DEFINE DELPHI7}
{$DEFINE DELPHI}
{$WARN UNSAFE_CODE OFF}
{$ENDIF}


//***********************************************************************

{$IFDEF BCB}
{$OBJEXPORTALL On}
{$ENDIF}

{$G+}

{$A-}

{$BOOLEVAL OFF} // no complete boolean eval

{.$IFDEF TESTING}
{.$ASSERTIONS ON}
{.$D+} {Enables and disables the generation of debug information}
{.$L+} {Enables or disables the generation of local symbol information}
{.$ELSE}
{.$ASSERTIONS OFF}
{.$D+} {Enables and disables the generation of debug information}
{.$L+} {Enables or disables the generation of local symbol information}
{.$ENDIF}

{==== Global fixed compiler options (do NOT change) ====}
{---Delphi ---}
{.$IFDEF DELPHI}
{$B- Incomplete boolean evaluation}
{$H+ Long string support}
{$J+ Writeable typed constants}
{$P- No open string parameters}
{$Q- No arithmetic overflow checking}
{$R- No range checking}
{$T- No type-checked pointers}
{$V- No var string checking}
{$X+ Extended syntax}
{$MINENUMSIZE 1}
{.$ENDIF}

{$IFDEF DELPHI7}
{$WARN UNSAFE_CODE OFF}
{$ENDIF}

{---C++Builder ---}
{$IFDEF BCB}
{$B- Incomplete boolean evaluation}
{$H+ Long string support}
{$J+ Writeable typed constants}
{$P- No open string parameters}
{$Q- No arithmetic overflow checking}
{$R- No range checking}
{$T- No type-checked pointers}
{$V- No var string checking}
{$X+ Extended syntax}
{$MINENUMSIZE 1}
{$ENDIF}




