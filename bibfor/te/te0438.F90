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

subroutine te0438(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/elref2.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/cginit.h"
#include "asterfort/cgtang.h"
#include "asterfort/cgepsi.h"
    character(len=16) :: option, nomte
!    - FONCTION REALISEE:  CALCUL DES OPTIONS EPSI_ELGA
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! =====================================================================
    character(len=8) :: typmod(2), lielrf(10)
    integer :: nno1, nno2, npg
    integer :: iepsi
    integer :: iw, ivf1, idf1, igeom
    integer :: npgn, iwn, ivf1n, idf1n, jgnn
    integer :: ivf2, idf2, nnos, jgn
    integer :: iddld
    integer :: ndim, ntrou
    integer :: iu(3, 3), iuc(3), im(3)
    real(kind=8) :: tang(3, 3)
! =====================================================================
    call elref2(nomte, 2, lielrf, ntrou)
    call elrefe_info(elrefe=lielrf(1),fami='RIGI',ndim=ndim,nno=nno1,nnos=nnos,&
  npg=npg,jpoids=iw,jvf=ivf1,jdfde=idf1,jgano=jgn)
    call elrefe_info(elrefe=lielrf(1),fami='NOEU',ndim=ndim,nno=nno1,nnos=nnos,&
  npg=npgn,jpoids=iwn,jvf=ivf1n,jdfde=idf1n,jgano=jgnn)
    call elrefe_info(elrefe=lielrf(2),fami='RIGI',ndim=ndim,nno=nno2,nnos=nnos,&
  npg=npg,jpoids=iw,jvf=ivf2,jdfde=idf2,jgano=jgn)
    ndim=3
! - DECALAGE D'INDICE POUR LES ELEMENTS D'INTERFACE
    call cginit(nomte, iu, iuc, im)

!
! - TYPE DE MODELISATION
!
    typmod(1) = '1D'
    typmod(2) = ' '
!
! - PARAMETRES EN ENTREE
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PDEPLAR', 'L', iddld)
!
!     DEFINITION DES TANGENTES
!
    call cgtang(3, nno1, npgn, zr(igeom), zr(idf1n),&
                tang)
    call jevech('PDEFOPG', 'E', iepsi)

    call cgepsi(ndim, nno1, nno2, npg, zr(iw),&
                zr(ivf1), zr(idf1), zr(igeom), tang,&
                zr(iddld),iu,iuc,zr(iepsi))

! ======================================================================
end subroutine
