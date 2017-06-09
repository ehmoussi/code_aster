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

subroutine ssdmrc(mag)
    implicit none
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
    character(len=8) :: mag
! ----------------------------------------------------------------------
!     BUT:
!        - INITILISER L' OBJET :  MAG.NOEUD_CONF    V V I DIM=NBNOE
!            POUR INO=1,NBNOE
!            SI (JNO= MAG.NOEUD_CONF(INO) .NE. INO) :
!               LE NOEUD INO A ETE  CONFONDU AVEC LE NOEUD JNO (<INO)
!               ATTENTION : LE NOEUD JNO PEUT ETRE LUI AUSSI CONFONDU
!                           AVEC UN AUTRE NOEUD KNO<JNO !!
!            SINON , LE NOEUD INO EST A CONSERVER.
!
!     IN:
!        MAG : NOM DU MAILLAGE QUE L'ON DEFINIT.
!
! ----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i,  iancnf, nnnoe
    integer, pointer :: dime(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    call jeveuo(mag//'.DIME', 'L', vi=dime)
    nnnoe=dime(1)
    call wkvect(mag//'.NOEUD_CONF', 'V V I', nnnoe, iancnf)
    do 1, i=1,nnnoe
    zi(iancnf-1+i)=i
    1 end do
    call jedema()
end subroutine
