! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
!
subroutine irtitr(lResu     , lField   ,&
                  dsNameZ   , meshNameZ,&
                  fileFormat, fileUnit ,&
                  title)
!
implicit none
!
#include "asterfort/gettco.h"
#include "asterc/gtoptk.h"
#include "asterfort/enlird.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
aster_logical, intent(in) :: lResu, lField
character(len=*), intent(in) :: dsNameZ, meshNameZ
character(len=8), intent(in) :: fileFormat
integer, intent(in) :: fileUnit
character(len=80), intent(out) :: title
!
! --------------------------------------------------------------------------------------------------
!
! Print result or field in a file (IMPR_RESU)
!
! Generate title and print it for RESULTAT and IDEAS
!
! --------------------------------------------------------------------------------------------------
!
! In  lResu            : flag if datastructure is a result
! In  lField           : flag if datastructure is a field
! In  dsName           : name of datastructure (result or field)
! In  meshName         : name of mesh
! In  fileFormat       : format of file to print (MED, RESULTAT, etc.)
! In  fileUnit         : index of file (logical unit)
! Out title            : title
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: lTitleFromResult
    integer :: iTitle, iret
    character(len=8) :: meshName
    character(len=16) :: date, resultType
    character(len=19) :: dsName
    character(len=24) :: dateur
    character(len=80) :: titleIdeas(7)
    integer :: resultTitleLineNb
    character(len=80), pointer :: resultTitleLine(:) => null()
    integer :: meshTitleLineNb
    character(len=80), pointer :: meshTitleLine(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    dsName   = dsNameZ
    meshName = meshNamez
!
! - Get title from datastructure ?
!
    lTitleFromResult = ASTER_FALSE
    if (lField .or. lResu) then
        call jeexin(dsName//'.TITR', iret)
        if (iret .ne. 0) then
            call jeveuo(dsName//'.TITR', 'L', vk80 = resultTitleLine)
            call jelira(dsName//'.TITR', 'LONMAX', resultTitleLineNb)
            lTitleFromResult = ASTER_TRUE
        else
            lTitleFromResult = ASTER_FALSE
        endif
    endif
!
! - Generate title
!
    title     = ' '
    if (lField .or. lResu) then
        if (lTitleFromResult) then
            title = resultTitleLine(1)
        else
            call gettco(dsName, resultType)
            write (title,'(1X,A,2X,A,2X,A,1X,A)') 'CONCEPT ', dsName, 'DE TYPE ', resultType
        endif
    endif
!
! - Write title in file for RESULTAT
!
    if (fileFormat .eq. 'RESULTAT') then
        if (lField .or. lResu) then
            if (lTitleFromResult) then
                write(fileUnit,'(1X,A)') (resultTitleLine(iTitle), iTitle = 1, resultTitleLineNb)
            else
                write (fileUnit,'(A)') title
            endif
        endif
    endif
!
! - Write title in file for IDEAS
!
    if (fileFormat .eq. 'IDEAS') then
        titleIdeas = ' '
! ----- Get title from mesh datastructure
        if (meshName .ne. ' ') then
            call jeexin(meshName//'           .TITR', iret)
            if (iret .ne. 0) then
                call jeveuo(meshName//'           .TITR', 'L', vk80 = meshTitleLine)
                call jelira(meshName//'           .TITR', 'LONMAX', meshTitleLineNb)
! ------------- Shift lines of title
                do iTitle = 1, min(6, meshTitleLineNb)
                    titleIdeas(iTitle+1) = meshTitleLine(iTitle)
                end do
            endif
        endif
! ----- Generate hour
        call enlird(dateur)
! ----- Get version of IDEAS
        titleIdeas(1) = ' ASTER V00.00.00 DU '
        call gtoptk('versionD0', titleIdeas(1)(9:16), iret)
        call gtoptk('date', date, iret)
        titleIdeas(1) = titleIdeas(1) (1:20)//date(1:10)//'  RESULTAT DU '
        titleIdeas(1) (45:69) = dateur
        titleIdeas(4) = ' '
! ----- Write title
        write (fileUnit,'(A)') '    -1'
        write (fileUnit,'(A)') '   151   %TITRE '
        do iTitle = 1, 7
            write (fileUnit,'(A)') titleIdeas(iTitle)
        end do
        write (fileUnit,'(A)') '    -1'
    endif
!
    call jedema()
end subroutine
