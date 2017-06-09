! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine te0549(option, nomte)
    implicit     none
#include "jeveux.h"
!
#include "asterc/r8vide.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/posvar.h"
    character(len=16) :: option, nomte
!    - FONCTION REALISEE:  EXTRACTION DES VARIABLES INTERNES EN THM
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ======================================================================
! ======================================================================
    integer :: ndim, nno, nnos, npg, ipoids, ivf, idfde, jgano
    integer :: ichg, icompo, ichgs, nume, i, ncmp, inova
! ======================================================================
! --- SELECTION DU TYPE D'INTEGRATION ----------------------------------
! ======================================================================
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PNOVARI', 'L', inova)
    call jevech('PCOMPOR', 'L', icompo)
!
    if (option .eq. 'VAEX_ELGA') then
!
        call jevech('PVARIGR', 'L', ichg)
        call jevech('PVARIGS', 'E', ichgs)
!
        call posvar(zk16(icompo), ndim, zk24(inova), nume)
!
        read (zk16(icompo+1),'(I16)') ncmp
!
        if (nume .gt. 0) then
            do 30 i = 1, npg
                zr(ichgs-1+i)=zr(ichg-1+(i-1)*ncmp+nume)
30          continue
        else
            do 40 i = 1, npg
                zr(ichgs-1+i)=r8vide()
40          continue
        endif
!
    else if (option.eq.'VAEX_ELNO') then
!
        call jevech('PVARINR', 'L', ichg)
        call jevech('PVARINS', 'E', ichgs)
!
        call posvar(zk16(icompo), ndim, zk24(inova), nume)
!
        read (zk16(icompo+1),'(I16)') ncmp
!
        if (nume .gt. 0) then
            do 50 i = 1, nno
                zr(ichgs-1+i)=zr(ichg-1+(i-1)*ncmp+nume)
50          continue
        else
            do 60 i = 1, nno
                zr(ichgs-1+i)=r8vide()
60          continue
        endif
!
    endif
!
end subroutine
