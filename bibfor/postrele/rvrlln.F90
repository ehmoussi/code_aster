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

subroutine rvrlln(xy, tn, n, repere, v1,&
                  v2)
    implicit none
!
!
#include "asterfort/rvrthe.h"
    character(len=8) :: repere
    integer :: tn(*), n
    real(kind=8) :: xy(*), v1(*), v2(*)
!
!***********************************************************************
!
!  OPERATION REALISEE
!  ------------------
!
!     CALCUL  DU REPERE LOCAL OU POLAIRE LA LONG D' UNE LISTE DE NOEUDS
!
!  ARGUMENTS EN ENTREE
!  -------------------
!
!     XY : COORDONNEES DES NOEUDS DU MAILLAGE
!     TN : LISTE DES NOEUDS
!     N  : NBR DE NOEUDS
!
!  ARGUMENTS EN SORTIE
!  -------------------
!
!     V1,V2 : VECTEURS DE LA BASE CALCULEES
!
!***********************************************************************
!
!  VARIABLES LOCALES
!  -----------------
!
    integer :: i
    real(kind=8) :: xc, xs, yc, ys, zzc, zzs, l
    real(kind=8) :: t1s, t2s, n1s, n2s, t1p, t2p, xaux, yaux, zaux, n1p, n2p
!
!====================== CORPS DE LA ROUTINE ===========================
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    xc = xy(3*(tn(1)-1)+1)
    yc = xy(3*(tn(1)-1)+2)
    zzc = xy(3*(tn(1)-1)+3)
!
    do 10, i = 1, n, 1
!
    if (i .ne. n) then
!
        xs = xy(3*(tn(i+1)-1)+1)
        ys = xy(3*(tn(i+1)-1)+2)
        zzs = xy(3*(tn(i+1)-1)+3)
!
    endif
!
    if (repere(1:5) .eq. 'LOCAL') then
!
        xaux = xs - xc
        yaux = ys - yc
        zaux = zzs - zzc
!
        if (i .ne. n) then
!
            l = sqrt(xaux*xaux + yaux*yaux + zaux*zaux)
            l = 1.0d0/l
!
        endif
!
        t1s = xaux*l
        t2s = yaux*l
        n1s = -t2s
        n2s = t1s
!
        if (i .eq. 1) then
!
            v1(2*i-1) = t1s
            v1(2*i ) = t2s
            v2(2*i-1) = n1s
            v2(2*i ) = n2s
!
        else if (i .ne. n) then
!
            v1(2*i-1) = 0.5d0*(t1s + t1p)
            v1(2*i ) = 0.5d0*(t2s + t2p)
            v2(2*i-1) = 0.5d0*(n1s + n1p)
            v2(2*i ) = 0.5d0*(n2s + n2p)
!
        else
!
            v1(2*i-1) = t1p
            v1(2*i ) = t2p
            v2(2*i-1) = n1p
            v2(2*i ) = n2p
!
        endif
!
        if (i .ne. n) then
!
            t1p = t1s
            t2p = t2s
            n1p = n1s
            n2p = n2s
!
        endif
!
    else
!
        call rvrthe(xc, yc, v1(2*i-1), v1(2*i), v2(2*i-1),&
                    v2(2*i))
!
    endif
!
    xc = xs
    yc = ys
    zzc = zzs
!
    10 end do
!
end subroutine
