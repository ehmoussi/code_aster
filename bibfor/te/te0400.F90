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

subroutine te0400(option, nomte)
    implicit none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/iselli.h"
#include "asterfort/jevech.h"
#include "asterfort/xcninv.h"
#include "asterfort/xvoise.h"
    character(len=16) :: option, nomte
!
!     BUT:
!         CREATION DE LA SD VOISIN POUR LES SOUS ELEMENTS D'UN ELEMENT
!         PARENT XFEM (2D):
!         ON ETABLIT LA TABLE DE CONNECTIVITE INVERSE DES SOUS-ELEMENTS
!         PUIS ON EN DEDUIT LES VOISINS DES SOUS ELEMENTS
!         OPTION : 'CHVOIS_XFEM'
!
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   OPTION : OPTION DE CALCUL
! IN   NOMTE  : NOM DU TYPE ELEMENT
!
! ......................................................................
!
!
!
!
    integer :: ninter, nnonsx
    parameter    ( ninter = 3 ,nnonsx=540 )
!
    integer :: ndim, nnop, nno, nse, nnotot
    integer :: jcnset, jlonch, ivoisx
    integer :: irese, i
    character(len=8) :: elrese(6), fami(6), elrefp
    integer :: vcninx(990)
!
    data    elrese /'SE2','TR3','TE4','SE3','TR6','T10'/
    data    fami   /'BID','RIGI','XINT','BID','RIGI','XINT'/
!
! ----------------------------------------------------------------------
!
!
!
!     ELEMENT DE REFERENCE PARENT
    call elref1(elrefp)
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nnop)
!
!     SOUS-ELEMENT DE REFERENCE : RECUP DE NNO
    if (.not.iselli(elrefp)) then
        irese=3
    else
        irese=0
    endif
!
    call elrefe_info(elrefe=elrese(ndim+irese),fami=fami(ndim+irese),nno=nno)
!
! --- RECUPERATION DES CHAMPS IN ET OUT
!
    call jevech('PCNSETO', 'L', jcnset)
    call jevech('PLONCHA', 'L', jlonch)
    call jevech('PCVOISX', 'E', ivoisx)
!
! --- PREALABLES
!
    nse = zi(jlonch-1+1)
    nnotot = nnop+ninter
!
! --- CALCUL DE LA CONNECTIVITE INVERSE
!
    ASSERT((nse+1)*nnotot.le.nnonsx)
    do 10 i = 1, nnonsx
        vcninx(i)=0
10  end do
    call xcninv(nnotot, nse, nnop, nno, jcnset,&
                vcninx)
!
! --- CALCUL DE LA SD VOISIN PAR SOUS ELEMENTS
!
    call xvoise(nnotot, nse, nnop, nno, jcnset,&
                vcninx, zi(ivoisx))
!
!
end subroutine
