
(* TODO: Add your comment here *)
FUNCTION_BLOCK FBReadFromFile
	CASE byStep OF
		0: (**** Error step ****)
			bOK := FALSE;
			byStep := 1;
		1: (**** Try to open existing file ****)
			(* Initialize file open structrue *)
			FOpen.enable    := 1;
			FOpen.pDevice   := ADR(strDevice);
			FOpen.pFile     := ADR(strFile);
			FOpen.mode      := fiREAD_ONLY;  (* Read and write access *)
			(* Call FBK *)
			FOpen();
			(* Get FBK output information *)
			dwIdent := FOpen.ident;
			wStatus := FOpen.status;
			(* Verify status (20708 -> File doesn't exist) *)
			IF (wStatus = 20708) THEN
				byStep := 0;
				//				מרטבךא םוע פאיכא
			ELSE
				byStep := 4;
				//				IF (wStatus = 0) THEN
				//					byStep := 3;
				//				ELSE
				//					IF (wStatus <> 65535) THEN
				//						byErrorLevel := 1;
				//						byStep := 0;
				//						IF (wStatus = 20799) THEN
				//							wError := FileIoGetSysError();
				//						END_IF
				//					END_IF
				//				END_IF
			END_IF
		2: (**** Wait for restart ****)
			IF Enable THEN
				byStep := 1;
			END_IF
			//		2: (**** Create file ****)
			//			(* Initialize file create structure *)
			//			FCreate.enable  := 1;
			//			FCreate.pDevice := ADR(strDevice);
			//			FCreate.pFile   := ADR(strFile);
			//			(* Call FBK *)
			//			FCreate();
			//			(* Get FBK output information *)
			//			dwIdent := FCreate.ident;
			//			wStatus := FCreate.status;
			//			(* Verify status *)
			//			IF (wStatus = 0) THEN
			//				byStep := 3;
			//			ELSE
			//				IF (wStatus <> 65535) THEN
			//					byErrorLevel := 2;
			//					byStep := 0;
			//					IF (wStatus = 20799) THEN
			//						wError := FileIoGetSysError();
			//					END_IF
			//				END_IF
			//			END_IF
		3: (**** Wait for command ****)
			IF Read THEN
				byStep := 4;
			END_IF
			//		3: (**** Write data to file ****)
			//			(* Initialize file write structure *)
			//			FWrite.enable   := 1;
			//			FWrite.ident    := dwIdent;
			//			FWrite.offset   := 0;
			//			FWrite.pSrc     := ADR(byWriteData[0]);
			//			FWrite.len      := SIZEOF(byWriteData);
			//			(* Call FBK *)
			//			FWrite();
			//			(* Get status *)
			//			wStatus := FWrite.status;
			//			(* Verify status *)
			//			IF (wStatus = 0) THEN
			//				byStep := 4;
			//			ELSE
			//				IF (wStatus <> 65535) THEN
			//					byErrorLevel := 3;
			//					byStep := 0;
			//					IF (wStatus = 20799) THEN
			//						wError := FileIoGetSysError();
			//					END_IF
			//				END_IF
			//			END_IF
		4: (**** Read data from file ****)
			(* Initialize file read structure *)
			FRead.enable    := 1;
			FRead.ident     := dwIdent;
			FRead.offset    := Offset;
			FRead.pDest     := ADR(ReadedStr);
			FRead.len       := BytesToRead;
			(* Call FBK *)
			IF Read THEN
				FRead();
				(* Get status *)
				wStatus := FRead.status;
				(* Verify status *)
				IF (wStatus = 0) THEN
					Read := FALSE;
					byStep := 3;
				ELSE
					IF (wStatus <> 65535) THEN
						byErrorLevel := 4;
						byStep := 0;
						IF (wStatus = 20799) THEN
							wError := FileIoGetSysError();
						END_IF
					END_IF
				END_IF
			END_IF
		5: (**** Close file ****)
			(* Initialize file close structure *)
			FClose.enable   := 1;
			FClose.ident    := dwIdent;
			(* Call FBK *)
			FClose();
			(* Get status *)
			wStatus := FClose.status;
			(* Verify status *)
			IF (wStatus = 0) THEN
				Enable := FALSE;
				byStep := 2;
			ELSE
				IF (wStatus <> 65535) THEN
					byErrorLevel := 5;
					byStep := 0;
					IF (wStatus = 20799) THEN
						wError := FileIoGetSysError();
					END_IF
				END_IF
			END_IF
		//		6: (**** Delete file ****)
		//			(* Initialize file delete structure *)
		//			FDelete.enable  := 1;
		//			FDelete.pDevice := ADR(strDevice);
		//			FDelete.pName   := ADR(strFile);
		//			(* Call FBK *)
		//			FDelete();
		//			(* Get status *)
		//			wStatus := FDelete.status;
		//			(* Verify status *)
		//			IF (wStatus = 0) THEN
		//				bOK     := TRUE;
		//				byStep := 7;
		//			ELSE
		//				IF (wStatus <> 65535) THEN
		//					byErrorLevel := 6;
		//					byStep := 0;
		//					IF (wStatus = 20799) THEN
		//						wError := FileIoGetSysError();
		//					END_IF
		//				END_IF
		//			END_IF
	END_CASE
END_FUNCTION_BLOCK
