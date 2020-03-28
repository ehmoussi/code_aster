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
! aslint: disable=W1504
!
subroutine ircnc8(fileUnit  , realFormat  , cplxFormat  ,&
                  nodeListNb, nodeListNume, nodeListName,&
                  lMeshCoor , meshDime    , meshCoor    ,&
                  cmpCataNb , cmpCataName ,&
                  cmpListNb , cmpListIndx ,&
                  nec       , nueq        ,&
                  prno      , codeInte    ,&
                  lmax      , lmin        ,&
                  lsup      , borsup      ,&
                  linf      , borinf      ,&
                  vale)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8pi.h"
#include "asterc/r8vide.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/exisdg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lxlgut.h"
!
integer, intent(in) :: fileUnit
character(len=8), intent(in) :: realFormat, cplxFormat
integer, intent(in) :: nodeListNb
integer, pointer :: nodeListNume(:)
character(len=8), pointer :: nodeListName(:)
aster_logical, intent(in) :: lMeshCoor
integer, intent(in) :: meshDime
real(kind=8), pointer :: meshCoor(:)
integer, intent(in) :: cmpCataNb
character(len=8), pointer :: cmpCataName(:)
integer, intent(in) :: cmpListNb
integer, pointer :: cmpListIndx(:)
integer, intent(in) :: nec
integer, pointer :: nueq(:), prno(:), codeInte(:)
aster_logical, intent(in) :: lsup, linf, lmax, lmin
real(kind=8),  intent(in) :: borsup, borinf
complex(kind=8), pointer  :: vale(:)
!
! --------------------------------------------------------------------------------------------------
!
! Print results - RESULTAT
!
! Field on nodes - Complex
!
! --------------------------------------------------------------------------------------------------
!
! In  fileUnit         : index of file (logical unit)
! In  realFormat       : format of real numbers
! In  cplxFormat       : format of complex numbers (IMAG, REAL, PHASE, MODULE or ' ')
! In  nodeListNb       : number of nodes
! Ptr nodeListNume     : pointer to the list of index of nodes
! Ptr nodeListNume     : pointer to the list of name of nodes
! In  lMeshCoor        : flag to print coordinates of nodes
! In  meshDime         : dimension of mesh (2 or 3)
! In  meshCoor         : coordinates of nodes of mesh
! In  cmpCataNb        : maximum number of components in catalog
! Ptr cmpCataName      : pointer to the list of components in catalog
! In  cmpListNb        : number of components
! Ptr cmpUserName      : pointer to the list of name of components
! Ptr cmpUserName      : pointer to the list of index of components
! In  lmax             : flag to print maximum value on nodes
! In  lmin             : flag to print minimum value on nodes
! In  lsup             : flag if supremum exists
! In  borsup           : value of supremum
! In  linf             : flag if infinum exists
! In  borinf           : value of infinum
! Ptr vale             : pointer to the (complex) values
!
! --------------------------------------------------------------------------------------------------
!
    character(len=1), parameter :: meshCmpName(3) = (/'X', 'Y', 'Z'/)
    character(len=8) :: fmtText
    character(len=50) :: fmtLine
    real(kind=8) :: value, valeMin, valeMax
    integer :: iCmp, iForm, iCmpCata, iNode
    integer :: cmpNume, nodeNume
    integer :: icompt, icomp2, iBegin, iec, ieq, iEnd, ilign
    integer :: impre, ipres, irest, ival
    integer :: fmtLen, nbCmp, nbCmpActi
    real(kind=8) :: rundf, c1
    integer, pointer :: inec(:) => null()
    real(kind=8), pointer :: valeReal(:) => null()
    real(kind=8), pointer :: valeImag(:) => null()
    real(kind=8), pointer :: valeComp(:) => null()
    integer, pointer :: valeIndx(:) => null()
    real(kind=8), pointer :: valeMaxReal(:) => null()
    real(kind=8), pointer :: valeMaxImag(:) => null()
    character(len=8), pointer :: valeMaxNode(:) => null()
    integer, pointer :: valeMaxNb(:) => null()
    real(kind=8), pointer :: valeMinReal(:) => null()
    real(kind=8), pointer :: valeMinImag(:) => null()
    character(len=8), pointer :: valeMinNode(:) => null()
    integer, pointer :: valeMinNb(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    c1      = 180.d0/r8pi()
    rundf   = r8vide()
    fmtLen  = lxlgut(realFormat)
!
! - Get length of text format from description of real format (to align !)
! - Ex realFormat = '1PE12.3' => fmtText = 'A12'. By default => 'A12'
!
    iBegin = 0
    iEnd   = 0
    do iForm = 1, fmtLen - 1
        if (realFormat(iForm:iForm) .eq. 'D' .or. realFormat(iForm:iForm) .eq. 'E' .or.&
            realFormat(iForm:iForm) .eq. 'F' .or. realFormat(iForm:iForm) .eq. 'G') then
            iBegin = iForm + 1
            cycle
        endif
        if (realFormat(iForm:iForm) .eq. '.') then
            iEnd = iForm - 1
            cycle
        endif
    end do
    if (iBegin .ne. 0 .and. iEnd .ge. iBegin) then
        fmtText = 'A'//realFormat(iBegin:iEnd)
    else
        fmtText = 'A12'
    endif
!
! - Working objects
!
    AS_ALLOCATE(vr = valeReal, size = cmpCataNb)
    AS_ALLOCATE(vr = valeImag, size = cmpCataNb)
    AS_ALLOCATE(vr = valeComp, size = cmpCataNb)
    AS_ALLOCATE(vi = valeIndx, size = cmpCataNb)
    if (nec .gt. 0) then
        AS_ALLOCATE(vi = inec, size = nec)
    endif
    if (lmax) then
        AS_ALLOCATE(vr = valeMaxReal, size = cmpCataNb)
        AS_ALLOCATE(vr = valeMaxImag, size = cmpCataNb)
        AS_ALLOCATE(vk8 = valeMaxNode, size = cmpCataNb)
        AS_ALLOCATE(vi = valeMaxNb, size = cmpCataNb)
        valeMaxReal = rundf
    endif
    if (lmin) then
        AS_ALLOCATE(vr = valeMinReal, size = cmpCataNb)
        AS_ALLOCATE(vr = valeMinImag, size = cmpCataNb)
        AS_ALLOCATE(vk8 = valeMinNode, size = cmpCataNb)
        AS_ALLOCATE(vi = valeMinNb, size = cmpCataNb)
        valeMinReal = rundf
    endif
!
    do iNode = 1, nodeListNb
        nodeNume = nodeListNume(iNode)
! ----- Get informations on physical quantity on the current node
        ival  = prno((nodeNume-1)*(nec+2)+1)
        nbCmp = prno((nodeNume-1)*(nec+2)+2)
! ----- Set current active components on the current node
        do iec = 1, nec
            codeInte(iec) = prno((nodeNume-1)*(nec+2)+2+iec)
        end do
        if (nbCmp .eq. 0) then
            cycle
        endif
! ----- Get values and position for each component
        valeIndx = 0
        icompt   = 0
        ipres    = 0
        do iCmpCata = 1, cmpCataNb
            if (exisdg(codeInte, iCmpCata)) then
! ------------- Index of equation for current component
                ipres = ipres + 1
                ieq   = nueq(ival-1+ipres)
                if (cmpListNb .ne. 0) then
! ----------------- Select in a list of components
                    do iCmp = 1, cmpListNb
                        cmpNume = cmpListIndx(iCmp)
                        if (iCmpCata .eq. cmpNume) then
                            valeReal(iCmp) = dble(vale(ieq))
                            valeImag(iCmp) = dimag(vale(ieq))
                            if (cplxFormat .eq. 'MODULE') then
                                valeComp(iCmp) = abs(vale(ieq))
                            elseif (cplxFormat .eq. 'PHASE') then
                                valeComp(iCmp) = atan2(dble(vale(ieq)),dimag(vale(ieq)))*c1
                            endif
                            valeIndx(iCmp) = iCmpCata
                            goto 12
                        endif
                    end do
                else
! ----------------- Select all components
                    icompt = ipres
                    valeReal(icompt) = dble(vale(ieq))
                    valeImag(icompt) = dimag(vale(ieq))
                    if (cplxFormat .eq. 'MODULE') then
                        valeComp(icompt) = abs(vale(ieq))
                    elseif (cplxFormat .eq. 'PHASE') then
                        valeComp(icompt) = atan2(dble(vale(ieq)),dimag(vale(ieq)))*c1
                    endif
                    valeIndx(icompt) = iCmpCata
                endif
            endif
 12         continue
        end do
! ----- Tassage
        if (cmpListNb .ne. 0) then
            icompt = 0
            do iCmp = 1, cmpListNb
                if (valeIndx(iCmp) .ne. 0) then
                    icompt = icompt+1
                    valeIndx(icompt) = valeIndx(iCmp)
                    valeReal(icompt) = valeReal(iCmp)
                    valeImag(icompt) = valeImag(iCmp)
                    valeComp(icompt) = valeComp(iCmp)
                endif
            end do
        endif
        impre = 0
        do iec = 1, nec
            if (codeInte(iec) .ne. inec(iec)) then
                impre = 1
                inec(iec) = codeInte(iec)
            endif
        end do
! ----- Total number of active components
        nbCmpActi = icompt
! ----- Select values between given boundaries
        if (lsup .or. linf) then
! --------- Désactivation des composantes en dehors des bornes
            do iCmp = 1, nbCmpActi
                value = sqrt(valeReal(iCmp)**2+valeImag(iCmp)**2)
                if (lsup) then
                    if ((value-borsup) .gt. 0.d0) valeIndx(iCmp) = 0
                endif
                if (linf) then
                    if ((value-borinf) .lt. 0.d0) valeIndx(iCmp) = 0
                endif
            end do
! --------- Tassage
            icomp2 = 0
            do iCmp = 1, nbCmpActi
                if (valeIndx(iCmp) .ne. 0) then
                    icomp2 = icomp2+1
                    valeIndx(icomp2) = valeIndx(iCmp)
                    valeReal(icomp2) = valeReal(iCmp)
                    valeImag(icomp2) = valeImag(iCmp)
                endif
            end do
            nbCmpActi = icomp2
        endif
        if (nbCmpActi .eq. 0) then
            cycle
        endif
! ----- Look for maximum value
        if (lmax) then
            do iCmp = 1, nbCmpActi
                if (valeMaxReal(valeIndx(iCmp)) .eq. rundf) then
                    valeMaxReal(valeIndx(iCmp)) = valeReal(iCmp)
                    valeMaxImag(valeIndx(iCmp)) = valeImag(iCmp)
                    valeMaxNode(valeIndx(iCmp)) = nodeListName(iNode)
                    valeMaxNb(valeIndx(iCmp))   = 1
                else
                    valeMax = sqrt(valeMaxReal(valeIndx(iCmp))**2 + valeMaxImag(valeIndx(iCmp))**2)
                    value   = sqrt(valeReal(iCmp)**2 + valeImag(iCmp)**2)
                    if (value .gt. valeMax) then
                        valeMaxReal(valeIndx(iCmp)) = valeReal(iCmp)
                        valeMaxImag(valeIndx(iCmp)) = valeImag(iCmp)
                        valeMaxNode(valeIndx(iCmp)) = nodeListName(iNode)
                        valeMaxNb(valeIndx(iCmp))   = 1
                    else if (value .eq. valeMax) then
                        valeMaxNb(valeIndx(iCmp)) = valeMaxNb(valeIndx(iCmp))+1
                    endif
                endif
            end do
        endif
! ----- Look for minimum value
        if (lmin) then
            do iCmp = 1, nbCmpActi
                if (valeMinReal(valeIndx(iCmp)) .eq. rundf) then
                    valeMinReal(valeIndx(iCmp)) = valeReal(iCmp)
                    valeMinImag(valeIndx(iCmp)) = valeImag(iCmp)
                    valeMinNode(valeIndx(iCmp)) = nodeListName(iNode)
                    valeMinNb(valeIndx(iCmp))   = 1
                else
                    valeMin = sqrt(valeMinReal(valeIndx(iCmp))**2 + valeMinImag(valeIndx(iCmp))**2)
                    value   = sqrt(valeReal(iCmp)**2 + valeImag(iCmp)**2)
                    if (value .lt. valeMin) then
                        valeMinReal(valeIndx(iCmp)) = valeReal(iCmp)
                        valeMinImag(valeIndx(iCmp)) = valeImag(iCmp)
                        valeMinNode(valeIndx(iCmp)) = nodeListName(iNode)
                        valeMinNb(valeIndx(iCmp))   = 1
                    else if (value .eq. valeMin) then
                        valeMinNb(valeIndx(iCmp)) = valeMinNb(valeIndx(iCmp))+1
                    endif
                endif
            end do
        endif
! ----- Print in file
        if (.not.lmax .and. .not.lmin .and. lMeshCoor) then
! --------- Print values of field  and coordinates of nodes
            ilign = (nbCmpActi+meshDime)/6
            irest = (nbCmpActi+meshDime)-ilign*6
! --------- Print head
            if (impre .eq. 1 .or. lsup .or. linf) then
                fmtLine = ' '
                if (irest .ne. 0) then
                    fmtLine = '(1X,A,6(1X,'//fmtText//'),30(/,9X,6(1X,'//fmtText//')))'
                else if (irest.eq.0 .and. ilign.eq.1) then
                    fmtLine = '(1X,A,6(1X,'//fmtText//'))'
                else
                    write(fmtLine,'(A,A8,A,I2,A,A8,A)') '(1X,A,6(1X,', fmtText, '),',&
                                                        (ilign-1), '(/,9X,6(1X,', fmtText, ')))'
                endif
                write (fileUnit,fmtLine) 'NOEUD   ', &
                                         (meshCmpName(iCmp), iCmp = 1, meshDime),&
                                         (cmpCataName(valeIndx(iCmp)), iCmp = 1, nbCmpActi)
            endif
! --------- Print values
            fmtLine = ' '
            if (irest .ne. 0) then
                fmtLine = '(1X,A,6(1X,'//realFormat//'),30(/,9X,6(1X,'//realFormat//')))'
            else if (irest.eq.0.and.ilign.eq.1) then
                fmtLine = '(1X,A,6(1X,'//realFormat//'))'
            else
                write(fmtLine,'(A,A10,A,I2,A,A10,A)') '(1X,A,6(1X,', realFormat, '),',&
                                                      (ilign-1),&
                                                      '(/,9X,6(1X,', realFormat, ')))'
            endif
            if (cplxFormat .eq. ' ' .or. cplxFormat .eq. 'REEL') then
                write (fileUnit,fmtLine) nodeListName(iNode), &
                                         (meshCoor((nodeNume-1)*3+iCmp), iCmp=1,meshDime),&
                                         (valeReal(iCmp), iCmp=1,nbCmpActi)
            endif
            if (cplxFormat .eq. ' ') then
                write (fileUnit,fmtLine) '        ',&
                                         (meshCoor((nodeNume-1)*3+iCmp), iCmp=1,meshDime),&
                                         (valeImag(iCmp),iCmp=1,nbCmpActi)
            endif
            if (cplxFormat .eq. 'IMAG') then
                write (fileUnit,fmtLine) nodeListName(iNode), &
                                         (meshCoor((nodeNume-1)*3+iCmp), iCmp=1,meshDime),&
                                         (valeImag(iCmp),iCmp=1,nbCmpActi)
            endif
            if (cplxFormat .eq. 'MODULE' .or. cplxFormat .eq. 'PHASE') then
                write (fileUnit,fmtLine) nodeListName(iNode), &
                                         (meshCoor((nodeNume-1)*3+iCmp), iCmp=1,meshDime),&
                                         (valeComp(iCmp),iCmp=1,nbCmpActi)
            endif
        else if (.not. lmax .and. .not. lmin) then
! --------- Print values of field only
            ilign = (nbCmpActi)/6
            irest = (nbCmpActi)-ilign*6
! --------- Print title
            if (impre .eq. 1 .or. lsup .or. linf) then
                fmtLine = ' '
                if (irest .ne. 0) then
                    fmtLine = '( 1X,A,6(1X,'//fmtText//'),30(/,9X,6(1X,'//fmtText//')))'
                else if (irest.eq.0.and.ilign.eq.1) then
                    fmtLine = '(1X,A,6(1X,'//fmtText//'))'
                else
                    write(fmtLine,'(A,A8,A,I2,A,A8,A)') '(1X,A,6(1X,', fmtText, '),',&
                                                        (ilign-1),&
                                                        '(/,9X,6(1X,', fmtText, ')))'
                endif
                write (fileUnit,fmtLine) 'NOEUD   ',&
                       (cmpCataName(valeIndx(iCmp)), iCmp=1, nbCmpActi)
            endif
! --------- Print values
            fmtLine = ' '
            if (irest .ne. 0) then
                fmtLine = '(1X,A,6(1X,'//realFormat//'),30(/,9X,6(1X,'//realFormat//')))'
            else if (irest .eq. 0 .and. ilign .eq. 1) then
                fmtLine = '(1X,A,6(1X,'//realFormat//'))'
            else
                write(fmtLine,'(A,A10,A,I2,A,A10,A)') '(1X,A,6(1X,', realFormat, '),',&
                                                      (ilign-1),&
                                                      '(/,9X,6(1X,', realFormat, ')))'
            endif
            if (cplxFormat .eq. ' ' .or. cplxFormat .eq. 'REEL') then
                write (fileUnit,fmtLine) nodeListName(iNode),&
                                         (valeReal(iCmp), iCmp = 1, nbCmpActi)
            endif
            if (cplxFormat .eq. ' ') then
                write (fileUnit,fmtLine) '        ',&
                                         (valeImag(iCmp), iCmp = 1, nbCmpActi)
            endif
            if (cplxFormat .eq. 'IMAG') then
                write (fileUnit,fmtLine) nodeListName(iNode),&
                                         (valeImag(iCmp), iCmp = 1, nbCmpActi)
            endif
            if (cplxFormat .eq. 'MODULE' .or. cplxFormat .eq. 'PHASE') then
                write (fileUnit,fmtLine) nodeListName(iNode),&
                                         (valeComp(iCmp), iCmp = 1, nbCmpActi)
            endif
        endif
    end do
    write (fileUnit,'(A)') ' '
!
! - Print maximum value
!
    if (lmax) then
        do iCmp = 1, cmpCataNb
            if (valeMaxReal(iCmp) .ne. rundf) then
                fmtLine = '(1X,3A,1X,'//realFormat//',1X,'//realFormat//',A,I4,A,A8)'
                write(fileUnit,fmtLine) 'LA VALEUR MAXIMALE DE ', cmpCataName(iCmp),&
                ' EST',valeMaxReal(iCmp),valeMaxImag(iCmp), ' EN ',valeMaxNb(&
                iCmp),' NOEUD(S) : ',valeMaxNode(iCmp)
            endif
        end do
    endif
!
! - Print minimum value
!
    if (lmin) then
        do iCmp = 1, cmpCataNb
            if (valeMinReal(iCmp) .ne. rundf) then
                fmtLine = '(1X,3A,1X,'//realFormat//',1X,'//realFormat//',A,I4,A,A8)'
                write(fileUnit,fmtLine) 'LA VALEUR MINIMALE DE ', cmpCataName(iCmp),&
                ' EST',valeMinReal(iCmp),valeMinImag(iCmp), ' EN ',valeMinNb(&
                iCmp),' NOEUD(S) : ',valeMinNode(iCmp)
            endif
        end do
    endif
!
    AS_DEALLOCATE(vr = valeReal)
    AS_DEALLOCATE(vr = valeImag)
    AS_DEALLOCATE(vr = valeComp)
    AS_DEALLOCATE(vi = valeIndx)
    AS_DEALLOCATE(vr = valeMaxReal)
    AS_DEALLOCATE(vr = valeMaxImag)
    AS_DEALLOCATE(vk8 = valeMaxNode)
    AS_DEALLOCATE(vi = valeMaxNb)
    AS_DEALLOCATE(vr = valeMinReal)
    AS_DEALLOCATE(vr = valeMinImag)
    AS_DEALLOCATE(vk8 = valeMinNode)
    AS_DEALLOCATE(vi = valeMinNb)
    AS_DEALLOCATE(vi = inec)
!
    call jedema()
end subroutine
