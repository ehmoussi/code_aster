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

subroutine rectfc(nbmode, nbvect, omeshi, npivot, nblagr,&
                  valpro, nvpro, resufi, resufr, nfreq)
    implicit   none
#include "asterc/r8miem.h"
    integer :: nbmode, nbvect, npivot, nblagr, nvpro, nfreq
    integer :: resufi(nfreq, *)
    complex(kind=8) :: omeshi, valpro(nvpro)
    real(kind=8) :: resufr(nfreq, *)
!     RECTIFIE LES VALEURS PROPRES COMPLEXES
!     ------------------------------------------------------------------
!     IN  : NBMODE  : NOMBRE DE MODE DEMANDES
!     IN  : NBVECT  : NOMBRE DE VECTEURS UTILISES AU COURS DU CALCUL
!     IN  : OMESHI  : DECALAGE UTILISE POUR LE CALCUL
!     IN  : NPIVOT  : NOMBRE DE PIVOTS NEGATIFS, POUR RECTIFIER LA
!                     POSITION DES MODES
!     IN  : NBLAGR  : NOMBRE DE PARAMETRES DE LAGRANGE
!     IN  : VALPRO  : VALEURS PROPRES
!     IN  : NVPRO   : DIMENSION DU VECTEUR VALPRO
!     OUT : RESUFI  : ON RANGE DANS LA STRUCTURE RESULTAT
!     OUT : RESUFR  : ON RANGE DANS LA STRUCTURE RESULTAT
!     IN  : NFREQ   : PREMIERE DIMENSION DU TABLEAU RESUFR
!     ------------------------------------------------------------------
    integer :: ineg, ip, im, in, ivec, ifreq
    complex(kind=8) :: om
    real(kind=8) :: prec
!     ------------------------------------------------------------------
!     INITS
!     PRECISION MACHINE COMME DANS ARPACK
    prec=(r8miem()*0.5d0)**(2.0d+0/3.0d+0)
!
!     ------------------------------------------------------------------
!     --------  RECTIFICATION DES FREQUENCES DUE AU SHIFT  -------------
!     --------     DETERMINATION DE LA POSITION MODALE     -------------
!     ------------------------------------------------------------------
!
    ineg = 0
    ip = 0
    im = 1
    do 10 ivec = 1, nbvect
        om = valpro(ivec)
        if (dble(om) .gt. 0.0d0) then
            ip = ip + 1
            in = ip
        else
            im = im - 1
            in = im
        endif
!
        om = om - omeshi
        if (dble(om) .lt. 0.d0) then
            ineg = ineg + 1
        endif
        if (ivec .le. nbmode) then
            resufi(ivec,1) = npivot+in
            resufr(ivec,2) = dble(om)
            if (abs(dble(om)) .lt. prec) then
                resufr(ivec,3) = 1.d+70
            else
                resufr(ivec,3) = (dimag(om) / dble(om)) /2.d0
            endif
        endif
10  end do
    if (ineg .eq. nbvect) then
        do 20 ivec = 1, nbmode
            resufi(ivec,1) = npivot + ivec
20      continue
    endif
!
!     ------------------------------------------------------------------
!     -- RECTIFICATION DE LA POSITION MODALE (A CAUSE DES LAGRANGE) ----
!     ------------------------------------------------------------------
!
    do 30 ifreq = 1, nbmode
        resufi(ifreq,1) = resufi(ifreq,1) - nblagr
30  end do
!
end subroutine
