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

subroutine te0345(option, nomte)
!
! aslint: disable=W0104
    implicit none
#include "jeveux.h"
#include "asterfort/cgforc.h"
#include "asterfort/cginit.h"
#include "asterfort/cgtang.h"
#include "asterfort/elref2.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES CHARGEMENTS
!                                  CHAR_MECA_PESA_R
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    character(len=8) :: lielrf(10)
    integer :: nno1, nno2, npg
    integer :: iw, ivf1, idf1, igeom, imate
    integer :: npgn, iwn, ivf1n, idf1n, jgnn
    integer :: ivf2, idf2, nnos, jgn
    integer :: ivectu, codret, ndim, ntrou
    integer :: iu(3, 3), iuc(3), im(3), isect, ipesa
    real(kind=8) :: tang(3, 3), a
!
!
! - FONCTIONS DE FORME
!
    call elref2(nomte, 2, lielrf, ntrou)
    call elrefe_info(elrefe=lielrf(1),fami='RIGI',ndim=ndim,nno=nno1,nnos=nnos,&
  npg=npg,jpoids=iw,jvf=ivf1,jdfde=idf1,jgano=jgn)
    call elrefe_info(elrefe=lielrf(1),fami='NOEU',ndim=ndim,nno=nno1,nnos=nnos,&
  npg=npgn,jpoids=iwn,jvf=ivf1n,jdfde=idf1n,jgano=jgnn)
    call elrefe_info(elrefe=lielrf(2),fami='RIGI',ndim=ndim,nno=nno2,nnos=nnos,&
  npg=npg,jpoids=iw,jvf=ivf2,jdfde=idf2,jgano=jgn)
    ndim=3
!
! - DECALAGE D'INDICE POUR LES ELEMENTS D'INTERFACE
    call cginit(nomte, iu, iuc, im)

    codret = 0
!
! - PARAMETRES EN ENTREE
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PPESANR', 'L', ipesa)
    call jevech('PCAGNBA', 'L', isect)
!
!
    call cgtang(3, nno1, npgn, zr(igeom), zr(idf1n),&
                tang)
!     SECTION DE LA BARRE
    a = zr(isect)
!
!
!
! PARAMETRES EN SORTIE
    call jevech('PVECTUR', 'E', ivectu)
!
!
    call cgforc(ndim, nno1, nno2, npg, zr(iw),&
                zr(ivf1), zr(idf1), zr(igeom), zi(imate), zr(ipesa),&
                iu, a, tang, zr(ivectu))
!
!
end subroutine
