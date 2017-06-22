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

subroutine calcq(s, gamcjs, pref, epssig, q,&
                 codret)
!
    implicit      none
#include "asterc/r8prem.h"
#include "asterfort/cjst.h"
#include "asterfort/cos3t.h"
#include "asterfort/hlode.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lcdevi.h"
#include "blas/ddot.h"
    integer :: codret
    real(kind=8) :: s(6), gamcjs, pref, epssig, q(6)
! --- BUT : CALCUL DE Q = DG/DSIG --------------------------------------
! ======================================================================
! IN  : NDT    : NOMBRE TOTAL DE COMPOSANTES DU TENSEUR ----------------
! --- : S      : DEVIATEUR DES CONTRAINTES -----------------------------
! --- : GAMCJS : PARAMETRE DU MODELE -----------------------------------
! --- : PREF   : PRESSION ATMOSPHERIQUE --------------------------------
! --- : EPSSIG : EPSILON -----------------------------------------------
! OUT : Q      : DG/DSIG = 1/H(T)**5* ----------------------------------
! ------------ :    ((1+GAMCJS*RCOS3T/2)*S/SII + -----------------------
! ------------ :  + GAMCJS*RAC(54)/(6*SII**2)*DEV(D(DET(S))/D(S))) -----
! ======================================================================
    integer :: ii, ndt, ndi
    real(kind=8) :: sii, t(6), devt(6), invh5, fact1, fact2
    real(kind=8) :: rhlode, rcos3t
    real(kind=8) :: un, deux, cinq, six
! ======================================================================
! --- INITIALISATION DE PARAMETRE --------------------------------------
! ======================================================================
    parameter       (  un     =  1.0d0  )
    parameter       (  deux   =  2.0d0  )
    parameter       (  cinq   =  5.0d0  )
    parameter       (  six    =  6.0d0  )
! ======================================================================
    common /tdim/   ndt , ndi
! ======================================================================
    call jemarq()
    codret = 0
! ======================================================================
! --- CALCUL DES VARIABLES UTILES --------------------------------------
! ======================================================================
    sii=ddot(ndt,s,1,s,1)
    sii = sqrt(sii)
    call cjst(s, t)
    call lcdevi(t, devt)
    rcos3t = cos3t(s, pref, epssig)
    rhlode = hlode(gamcjs, rcos3t)
    invh5 = un/(rhlode**cinq)
! ======================================================================
! --- VARIABLES INTERMEDIAIRES -----------------------------------------
! ======================================================================
    if (sii .lt. r8prem()) goto 100
    fact1 = invh5*(un+gamcjs*rcos3t/deux)/sii
    fact2 = invh5*gamcjs*sqrt(54.0d0)/(six*sii*sii)
! ======================================================================
! --- CALCUL FINAL -----------------------------------------------------
! ======================================================================
    do 10 ii = 1, ndt
        q(ii) = fact1*s(ii)+fact2*devt(ii)
10  end do
    goto 200
! ======================================================================
100  continue
    codret = 2
200  continue
    call jedema()
! ======================================================================
end subroutine
