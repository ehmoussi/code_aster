! --------------------------------------------------------------------
! Copyright (C) 2007 NECS - BRUNO ZUBER   WWW.NECS.FR
! Copyright (C) 2007 - 2017 - EDF R&D - www.code-aster.org
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

subroutine te0207(option, nomte)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/nmfifn.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: nomte, option
!
! ----------------------------------------------------------------------
!     FORCES NODALES DES ELEMENTS DE JOINT 3D, OPTION 'FORC_NODA'
! ----------------------------------------------------------------------
!
!
    integer :: ndim, nno, nnos, npg, nddl
    integer :: ipoids, ivf, idfde, jgano
    integer :: igeom, icont, ivect
! ----------------------------------------------------------------------
!
!
!
! -  FONCTIONS DE FORMES ET POINTS DE GAUSS : ATTENTION CELA CORRESPOND
!    ICI AUX FONCTIONS DE FORMES 2D DES FACES DES MAILLES JOINT 3D
!    PAR EXEMPLE FONCTION DE FORME DU QUAD4 POUR LES HEXA8.
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    if (nno .gt. 4) then
        call utmess('F', 'ELEMENTS5_22')
    endif
    if (npg .gt. 4) then
        call utmess('F', 'ELEMENTS5_23')
    endif
!
    nddl = 6*nno
!
! - LECTURE DES PARAMETRES
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCONTMR', 'L', icont)
    call jevech('PVECTUR', 'E', ivect)
!
    call nmfifn(nno, nddl, npg, zr(ipoids), zr(ivf),&
                zr(idfde), zr(igeom), zr(icont), zr(ivect))
!
end subroutine
