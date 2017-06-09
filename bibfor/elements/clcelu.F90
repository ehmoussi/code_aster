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

subroutine clcelu(piva, pivb, effm, effn, ht,&
                  enrobg, sigaci, sigbet, es, dnsinf,&
                  dnssup, epsilb, ierr)
!______________________________________________________________________
!
!     CC_ELU
!
!      DETERMINATION DES ARMATURES EN FLEXION COMPOSEE, CONDITIONS ELU
!
!      I PIVA        VALEUR DU PIVOT A
!      I PIVB        VALEUR DU PIVOT B = DEFORMATION MAXI. DU BETON
!      I EFFM        MOMENT DE FLEXION
!      I EFFN        EFFORT NORMAL
!      I HT          EPAISSEUR DE LA COQUE
!      I SIGACI      CONTRAINTE ADMISSIBLE DANS L'ACIER
!      I SIGBET      CONTRAINTE ADMISSIBLE DANS LE BETON
!      I ES          MODULE D'YOUNG DE L'ACIER
!      O DNSINF      DENSITE DE L'ACIER INFERIEUR
!      O DNSSUP      DENSITE DE L'ACIER SUPERIEUR
!      O EPSILB      DEFORMATION DU BETON
!      O IERR        CODE RETOUR (0 = OK)
!
!______________________________________________________________________
!
!
    implicit none
!
    real(kind=8) :: piva, es, epsy, epsila
    real(kind=8) :: pivb
    real(kind=8) :: effm
    real(kind=8) :: effn
    real(kind=8) :: ht
    real(kind=8) :: enrobg
    real(kind=8) :: sigaci, sigacim
    real(kind=8) :: sigbet
    real(kind=8) :: dnsinf
    real(kind=8) :: dnssup
    real(kind=8) :: epsilb
    integer :: ierr
!
!       EPAISSEUR UTILE DEPUIS L'ACIER JUSQU'A LA FIBRE SUP COMPRIMEE
    real(kind=8) :: hs
!       EPAISSEUR DEPUIS L'ACIER JUSQU'AU MILIEU DE LA SECTION
    real(kind=8) :: hu
!       EPAISSEUR RELATIVE DU BETON COMPRIME
    real(kind=8) :: alpha
!       EPAISSEUR RELATIVE DU BETON COMPRIME LIMITE PIVOT A ET B
    real(kind=8) :: alphab
!       MOMENT MESURE A PARTIR DE L'ACIER
    real(kind=8) :: ms
!       MOMENT REDUIT
    real(kind=8) :: mub
!
    real(kind=8) :: moment
    real(kind=8) :: tmp
!
    ierr = 0
!
    moment = -effm
!
    hs = ht - enrobg
    hu = 0.5d0 * ht - enrobg
!
    dnsinf = 0d0
    dnssup = 0d0
    epsilb = 0d0
    sigacim = sigaci
    epsy=sigaci/es
    ms = abs(moment) - effn * hu
    alphab = pivb/(piva+pivb)
!
    if (ms .lt. 0d0) then
!         BETON ENTIEREMENT TENDU
        tmp = 0.5d0 * (effn + moment / hu)
        dnsinf = tmp
        dnssup = effn - tmp
    else
!         BETON PARTIELLEMENT COMPRIME
        mub = ms / (hs * hs * sigbet)
!
        if (mub .lt. 0.48d0) then
            alpha = 1d0 - sqrt(1d0 - 2d0 * mub)
            epsilb = piva * alpha / (1d0 - alpha)
            tmp = ms / (hs * (1d0 - alpha / 2d0)) + effn
!            PIVOT A (PIVOT C NON TRAITE )
            if (tmp .gt. 0d0) then
                if (0d0 .lt. moment) dnsinf = tmp
                if (moment .lt. 0d0) dnssup = tmp
                if (alpha .gt. alphab) then
! PIVOT B ET 2 CAS
                    epsila = pivb*(1-alpha)/alpha
                    epsilb = pivb
                    if (epsila .lt. epsy) then
                        sigacim = es*epsila
                    endif
                endif
            else
              ierr = 1020
              dnsinf = 0.0d0
              dnssup = 0.0d0
              !goto 999
            endif
        else
            ierr = 1040
            dnsinf = 0.0d0
            dnssup = 0.0d0
            goto 999
        endif
    endif
    dnsinf = dnsinf / sigacim
    dnssup = dnssup / sigacim
!
999  continue
end subroutine
