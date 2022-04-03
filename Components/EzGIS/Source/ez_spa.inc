  { (c) 2002 EzGis - EzGis main constants  }

  { Command line commands }
  SCommand = 'Comando: ';

  SFeature= 'Feature';
  SRange= 'Range';
  SFrequency= 'Frequency';
  SSymbolCaption = 'SYMBOL %d';
  SLinetypeCaption = 'LINETYPE %d';
  SScaleFmt = 'Escala = %.3f %%';
  STranslateFmt = 'DX = %.3f, DY = %.3f, < %.3f';
  SRotateFmt = '< %.3f';
  SNewEntityInfo = '< %.*n, DX = %.*n, DY = %.*n, Area = %.*n, Dist = %.*n';
  SIsInvalidFloatValue = 'Valor de punto flotante invalido %s';
  SIsInvalidIntegerValue = 'Valor entero invalido %s';
  SIsInvalidBoolValue = 'Valor logico invalido %s';
  SLauncher= 'Launcher';
  SDragDropClick= 'Haga click en entidad que desea arrastrar';
  STextRefPtFirst= 'Define la posicion del texto';
  SIndivClickToEdit= 'Haga click en entidad deseada para mostrar/editar informacion';
  SEntityClickCaption= 'Haga click en entidad en el mapa';
  SSymbolTextCaption= 'Texto del simbolo';
  SSymbolText= 'Texto :';
  SUnconnectedDrawBox= 'El componente no esta conectado a un TEzBaseDrawBox';
  SMsgConfirm= 'Confirmar';
  SMsgError= 'Error';
  SMsgWarning= 'Cuidado';
  SMsgInfo= 'Informacion';
  SWrongBuffer= 'No puedo crear un buffer de esta polilinea';
  SCannotCreateBuffer= 'No puedo crear un buffer para este tipo de entidad';
  SCannotContainParams= 'El campo %s de la tabla no puede tener parametros !';
  SWrongLayername= 'Nombre de capa erroneo %s, o la capa no es visible o editable';
  SWrongParameters= 'Parametro(s) invalido(s) para la funcion %s';
  SExprParserError= ' %s en linea : %d, Columna: %d, palabra: %s';
  SBadExtension= 'Coordenadas de esquina erroneos !' + CrLf +
                 'Primera esquina debe estar abajo y a la izquierda';
  SRestNotExclusive= 'No puedo abrir archivo en modo exclusivo !';
  SRestructuring= 'Restructurando tabla';
  SDuplicateLayer= 'Nombre de capa ya existe o' + CrLf +
                   'existe un archivo con el mismo nombre en disco.';
  SRecnoInvalid= 'Registro fuera de rango';
  SRebuildTree= 'Reconstruyendo r-tree %s...';
  SDBFNotFound= 'Archivo de datos de esta capa no puede ser encontrado.' + CrLf +
                'La capa se deja sin un archivo adjunto';
  SUpdateExtension= 'Actualizando capa %s';
  SThereAreNoDeleted= 'No hay entidades eliminadas. Desea usted' + CrLf +
                     'continuar para efectuar una evaluacion de esta capa ?';
  SPackingLayer= 'Compactando capa...';
  SWrongRecordsRecover= 'No puedo recuperar %d registros dañados';
  SExprFail= 'Expresion no es de tipo logico !';
  SCannotDeleteLayer= 'La capa no puede ser eliminada.' + CrLf +
                      'Probablemente esta siendo usada en una red';
  SInternalListError= 'Error interno en la lista';
  SLayerFilesNotFound= 'No puedo encontrar los archivos que forman la capa %s !' + CrLf +
                       'La capa sera eliminada del mapa';
  SPrinterIsBusy= 'Impresora esta ocupada';
  SGISListError= 'Indice erroneo en DrawBoxList';
  SGISUnassigned= 'NoAsignado';

  SEzImplMissed= 'Debe usted incluir unidad ezimpl.pas en su proyecto';
  SNoGISDefined= 'No hay un componente basico ligado';
  SSelectinLayer= 'Seleccionado capa ';
  SEntityNotClosed= 'Entidad no esta cerrada. No puedo recortar';
  SMultiPartNotSupported= 'Entidades multi-partes no soportadas en esta version';
  SLayerNotFound= 'Nombre de capa no encontrado';
  SCannotGroup= 'Puedo agrupar entidades de la misma capa solamente';

  SUndoDelete= 'Deshacer borrar';
  SUndoInsert= 'Undo insert';
  SCannotUndo= 'No puedo deshacer';
  SUndoTransform= 'Deshacer transformar';

  SFlatScrollBarNotAllowed='No puedo usar barras delgadas ' +CrLf+
                           'la version de COMCTL32.dll en este sistema es menor de 4.71';

  SEntityOutOfBound= 'Numero de entidad fuera de rango !';
  SInvalidSymbolFile= 'Formato de archivo erroneo para simbolos';
  SSymbolOutOfBound= 'Numero de simbolo fuera de rango !';

  SInvalidSymbolVersion= 'Version del archivo esta equivoada !';
  SWrongImageFormat= 'El formato del archivo no es soportado';

  SEntListIndexError= 'Indice en la lista fuera de rango';
  SEntListCountError= 'Error en Numero elementos en lista';
  SEntListCapacityError= 'Error en capacidad';
  SVectorOutOfBound= 'Vector fuera de limites';


  SDefineFromPoint= 'Desde punto :';
  SDefineToPoint= 'Hasta punto :';
  SFirstPoint= 'Primer punto :';
  SSecondPoint= 'Segundo punto :';
  SThirdPoint= 'tercer punto :';
  SFourthPoint= 'Cuarto punto :';
  SFifthPoint= 'Quinto punto :';
  SNextPoint= 'Siguiente punto :';
  SClipPolygon= 'Recortando entidad, '; // 'Clip Polygon, ';
  SCircleCenter= 'Centro :';
  SCircleRadius= 'Radio :';
  SArcSweepAngle= 'Defina angulo de apertura:';
  SCircleEndPoint= 'Define el primer punto del arco';
  

  SRealTimeZoom= 'Presione boton izquierdo y arrastre verticalmente para acercar';

  SDefineFirstZoomPoint= 'primer esquina';
  SDefineSecondZoomPoint= 'Otra esquina';

  SNotEnoughData= 'Necesito mas puntos para construir entidad !';

  SStartSingleSelect= 'Haga click en una entidad para seleccionar. SHIFT selecciona uno';

  SDefineBasePoint= 'Punto base  :';
  SDefineEndPoint= 'Ultimo punto :';

  SReferenceFirstPoint= 'Longitud de referencia, primer punto :';
  SReferenceSecondPoint= 'Longitud de referencia, segndo punto :';
  STransformLastPoint= 'Ultimo punto :';
  SRotTransformLastPoint= 'Ultimo punto o angulo :';

  SDefineSecondSelection= 'Otra esquina de seleccion';
  SWarnNoSelection= 'No hay entidades seleccionadas !';
  SVertexSingleEntityError= 'Solo una entidad debe estar seleccionada para esta operacion !';
  SInsertVertexPoint= 'Haga click en el nuevo punto para el vertice seleccionado';
  SVertexEntityBadError= 'Puede usted agregar vertices a polilineas y poligonos solamente !';
  SChangeGridOrigin= 'Por favor haga click en el nuevo origen de la rejilla :';
  SShowHintCaption= 'Mueva el mouse encima de la entidad, y haga click para mostrar sugerencia. Haga click de nuevo para entidades apiladas. <Esc> finish';
  SVectorialFirstPt= ' Definr area, primer esquina :';
  SVectorialSecondPt= 'Definir area, otra esquina:';


  SSelectRefEntity= 'Selecione la entidad de referencia';
  SBreakSelectFirstPoint= 'Seleccione primer punto de la entidad';
  SBreakSelectSecndPoint= 'Seleccione segundo punto';
  SBreakWrongSelection= 'Debe usted hacer click en la misma entidad';
  SBreakWrongEntity= 'No puedo romper esta entidad';
  SBreakNotClicked= 'No se encontraron entidades';
  STrimNoCuttingEdge= 'No hay frontera de recorte seleccionada';
  SExtendNoExtendEdge= 'No hay frontera de extension seleccionada';
  STrimSelectEnt = 'Seleccione entidad a cortar';
  SExtendSelectEnt= 'Seleccione entidad a extender';
  STrimWrongEntity= 'No puedo cortar esta entidad';
  SExtendWrongEntity= 'No puedo extender esta entidad';
  SExtendWrongSegment= 'No puedo extender este segmento';
  STrimOnlyOneCuttingEdge= 'Solo una frontera de recorte es soportada';
  SExtendOnlyOneCuttingEdge= 'Solo una frontera de extension es soportada';
  SFilletWrongEntity= 'No puedo filetear esta entidad';
  SFilletNotContiguous= 'No se seleccionaron segmentos contiguos';
  STrimCuttingEdge= 'No puedo cortar la frontera de recorte';
  SFirstExtensionLine= 'Primera linea de extension, origen';
  SSecondExtensionLine= 'Segunda linea de extensnioni, origen';
  SDefineTextLocation= 'Localizacion del texto';


  SBlobErrNotEditing= 'Dataset no esta en modo de insercion o edicion';
  SCannotOpenDesignMode= 'No puedo abrir en modo de diseño';
  SLayerNotAssigned= 'La propiedad Layer no esta asignada o no esta visible';
  SLayerEmpty= 'Nombre de capa no esta definido';
  SExpressionEmpty= 'Expresion o nombre de campo no puede estar vacio';
  SWrongFieldnameCol= 'NOmbre de campo erroneo, columna %d';
  SGetRecordInvalid= 'Error al leer el registro';
  SInsertNotAllowed= 'Insertion no es permitida';
  SWrongReadOnly= 'No puedo cambiar la propiedad de solo-lectura cuando esta abierto';

  SLatLonMismatch= 'Archivo destino esta en un diferente sistema de coordenadas' + CrLf +
                   'Accion cancelada';
  SWrongProjParams= 'Parametros para esta proyeccion son erroneos';
  SWrongProjector= 'Propiedad Projector no esta definida';
  SLayerAlreadyExists= 'Hay una capa con el mismo nombre.'+CrLf+
                       'Desea usted reemplazar la capa existente ?';
  SCannotCreateNewLayer= 'La nueva capa no puede ser creada !';
  SWrongEzGIS= 'Propiedad GIS no asignada';
  SProjEditSource= 'Seleccione sistema de coordenadas de archivo origen';
  SProjEditDestin= 'Seleccione sistema de coordenadas de archivo destino';


  SDXFReading= 'Leyendo archivo AutoCAD...';
  SDXFPolylineBad = 'Polilinea contiene mas de %d vertices %d';
  SDXFInvalidFloat= 'Conversion de punto flotante invalida';
  SDXFInvalidInteger= 'Conversion de enteros invalida';
  SDXFFileReadingNow= ' Archvo DXF leyendo ahora..';
  SDXFUndefBlock = 'Referencia a un bloque indefinido';
  SDXFWrongBlockInfo= 'Este dibujo tiene informacion de bloques erronea,'+crlf+
                      'pero se puede continuar leyendo al ignorar ...';
  SDXFLWPolylineBad= 'LwPolyline contiene mas de %d vertices %d';
  SDXFPOINTBad= 'Error al leer entidad POINT ';
  SDXFINSERTBad= 'Error al leer entidad INSERT';
  SDXFTEXTBad= 'Error al leer entidad TEXT';
  SDXFLINEBad= 'Error al leer entidad LINE';
  SDXFPOLYLINEBad2= 'Error al leer entidad POLYLINE';
  SDXFLWPOLYLINEBad2= 'Error al leer entidad LWPOLYLINE';
  SDXF3DFACEBad= 'Error al leer entidad 3DFACE';
  SDXFSOLIDBad= 'Error al leer entidad SOLID';
  SDXFCIRCLEBad= 'Error al leer entidad CIRCLE';
  SDXFARCBad= 'Error al leer entidad ARC';
  SDXFATTDEFBad= 'Error al leer entidad ATTDEF';
  SDXFATTRIBBad= 'Error al leer entidad ATTRIB';
  SDXFThereIsNoHeader= 'No Header o seccon del Header invalido en archivo DXF';
  SDXFThereIsNoLayers= 'No hay capas o seccion Tables invalida en archivo DXF';
  SDXFThereIsNoBlocks= 'No Bloques o seccion Blocks invalido en archivo DXF';
  SDXFThereIsNoEntities= 'No hay Entidades o seccion Entities es invalida en archivo DXF';
  SDXFThereIsNoMaxMin= 'Archivo no contiene extension Max/Min extents. Calculando...';
  SDXFErrorInLine= 'Un error ocurrio en o cerca de linea ';
  SDXFDupLayer= 'Falla al intentar crear una capa con nombre duplicado';
  SDXFNoName= 'Falla al intentar agregar una capa sin nombre';
  SDXFCannotSave= 'Quiza el directorio destino es de un CDRom o'+CrLf+
                  'no hay espacio en disco suficiente,no puedo guardar. Cuidado!';


  STextIsNotVisible= 'Texto esta invisible !' + CrLf +
                     'El texto insertado sera invisible';
  SInsertText= 'Haga clicn en el punto de insercion del texto';
  SEntityToReshape= 'Seleccione la entidad a modificar';
  SReshapeToPoint= 'Mover al punto (Presione CTRL para mover origin de rotacion):';
  SVertexToReshape= 'Seleccione vertice a modificar';
  SVertexToDelete= 'Seleccione nodo a eliminar';
  SClickInterestPoint= 'Haga click en el punto';
  SEntityToDrag= 'Seleccione una entidad a arrastrar y soltar';
  SDragFromCtrlPt= 'Arrastrar de un punto de control';


  SDefineCircleCenter= 'Haga click en el centro del circulo de seleccion';
  SDefineCircle= 'Mueva el mouse para definir el circulo de seleccion';
  SAreaAndPerimeter= 'Area = %.*n %s' + CrLf +
                     'Longitud = %.*n %s' + CrLf +
                     'Angulo = %.2n' + CrLf +
                     'Puntos = %.2n';
  SZoomUnZoom= 'Haga click en el punto a acercar/alejar';
  SScrolling= 'Presione el boton izquierdo y mueva el mouse para desplazar';
  SInsertXGuideLine= 'Coordenada X para linea guia :';
  SInsertYGuideLine= 'Coordenada Y para linea guia :';
  SSelectGline= 'Seleccione la linea guia a mover';
  SMoveGLinetoNew= 'Mueva la linea guia a su nueva posicion';


  SUnrecognizedCommand= 'Comando desconocido !';
  SShpFileNotFound= 'El archivo %s no fue encontrado !' + CrLf +
                    'No puedo importar el archivo';
  SThereAreNoLayers= 'Usted necesita al menos una capa !';
  SDLLLoadError = 'Error al cargar la libreria DLL !';
  SGridTooDense= 'Grid demasiado denso para desplegar';
  Sscrcanceled= 'Script cancelado';
  SEmptyTable= '<Empty Table>';
  SPageid='Pagina %d';
  SROwCol='Renglon %d, Columna %d';
  SWrongFontSize= 'Tamaño de fuente demasiado pequeño !';
  SLoadingCAD= 'Cargando capa %s';
  SSavingCAD= 'Guardando capa %s';
  SWrongCADFile= 'El archivo no es un archivo EzCAD !';
  SFileAlreadyExists= 'El archivo ya existe !';
  STextInfo= 'Altura: %.2n Puntos; %.2n unidades';
  SErrWrongField= 'Definicion de campo erronea';

  SMBToomanyfields= 'Demasiados campos seleccionados para crear el tematico';
  SCalculatingRanges= 'Calculando...';
  SExpresionNull= 'Expresion esta vacia';
  SWrongFieldName= 'Nombre de campo no existe';

  SCircleInfo= 'Radio = %.*n; Area = %.*n; Perimetro = %.*n';
  SBufferRefInfo= 'Radio = %.*n';
  SOneSelection= 'Seleccionado en capa %s, Registro %d';
  SMultiSelection= '%d entidades seleccionadas';
  SUnknownFormat= 'Formato de archivo desconocido';
  SNoNodeClicked= 'Ningun nodo fue seleccionado';

  { networkd messages }
  SNetSameNodes= 'No puedo ligar al mismo nodo';
  SNetExpressionNotNumeric= 'Expresion no es de tipo numerica';
  //SNetWrongFIleID = 'File ID mismatch. This is not a Network Analyst file';
  //SNetWrongFIleVersion = 'File version mismatch with software version';
  //SNetWrongFilename = 'The defined file does not exists';
  //SNetCannotCreateDir = 'Cannot create directory for network files';
  //SNetExpressionNotNumeric = 'The expression is not of numeric type';
  //SNetCreatingNetwork = 'Creating Network...';
  //SNetNodesOverlap = 'There are nodes that overlaps.'#13#10'Do you want to see the exact location ?';
  //SNetLayernameMismatch = 'Layer name mismatch with the linked layer';
  //SNetNodeToMove = 'Pick the node to move';
  //SNetMoveNodeTonew = 'Move node to new position';
  //SNetGraphicPickN = 'Picked Point %d';
  //SNetTotalCost = 'Total Route Cost: %n';
  //SNetNumberOfStops = 'Number of stops: %d';
  //SNetLoadStops = 'Load stops from layer';
  //SNetAddStopsCaption = 'Click a point where you wish to add a stop';
  //SNetInvalidLayer = 'The layer does not have attached a DBF file';
  SNetDirections1 = 'Iniciando desde primer punto elegido %d';
  SNetDirections2 = '  Viaje por la %s para %.*n %s';
  SNetContinueStraight = 'Continue derecho en %s';
  SNetDirections3 = 'Gire a la %s en %s';
  SNetDirections4 = 'Costo total del viaje es %.*n %s';
  SNetDirections5 = '=====================';
  SNetRight = 'Derecha';
  SNetLeft = 'Izquierda';
  SNetCleaning = 'Limpiando capa...';
  //SNetWrongLayer = 'Cannot clean-up for this layer.'#13#10'Currently in use.';
  //SNetBestRouteNotShown = '"Find Best Route" form is not opened';
  //SNetCleanCaption = 'Clean up a layer';
  //SNetOpenCaption = 'Open network for layer';
  //SNetConfirmDeletion = 'Okay to delete selected links?';
  SNetUnits= 'Unidades';
  SDGNWrongHeader= 'File `%s'' does not have expected DGN header';
  SNoneColorTextInColorPicker= 'Transparent';
  SCustomTextInColorPicker= '&More Colors...';
  SLayerIndexOutOfRange= 'Indice de la capa fuera de rango';
  sDrawBoxCollectionNotSame= 'All member of collection must have same TEzBaseGIS';

  { dic/1/2002 }
  SFilterEnabled= 'A filter is active';
  SBFFFolderName= 'C:\';
  SBFFSTatusText= 'Plase select folder';
  SBFFCaption= 'Select Folder';
  { layer list box }
  SLLBCurrent= 'Currente';
  SLLBVisible= 'Visible';
  SLLBSelectable= 'Seleccionable';
  SLLBLayerName= 'Nombre';

  SNoImagesFound= 'No images/files found on %s';
  SSelectImgTitle= 'Select Image/Element';
  SBandedImagesFilter= 'Windows Bitmaps (*.BMP)|*.BMP' +
                       '|ESRI Band Interleaved by Line (*.BIL)|*.BIL' +
                       '|TIFF files (*.TIF)|*.TIF';
  SBitmapFilter = 'Windows Bitmap (*.BMP)|*.BMP';
  SJPGFilter= 'Jpeg (*.JPG) |*.JPG';
  SMetafileFilter = 'Windows Metafile (*.WMF)|*.WMF|Windows Enhanced Metafile (*.EMF)|*.EMF';
  SICOFilter = 'Windows ICON files (*.ICO)|*.ICO';
  SGIFFilter= 'Compuserve Gif (*.GIF)|*.GIF';
  STIFFilter= 'TIFF files (*.TIF)|*.TIF';
  STargaFilter= 'True Vision images (*.TGA)|*.TGA';
  SPCXFilter= 'PCX files (*.PCX)|*.PCX';
  SPCDFilter= 'Kodak Photo CD images (*.PCD)|*.PCD';
  SPSDFilter= 'PhotoShop images (*.PSD)|*.PSD;*.PDD';
  SPSPFilter= 'PaintShopPro images (*.PSP)|*.PSP';
  SPNGFilter= 'Portable Network Graphics images (*.PNG)|*.PNG';

  SEDBFilter= 'EzGIS blocks (*.EDB)|*.EDB';
  SChangeDirNotAllowed= 'You must select the file on the common subdir only !';

