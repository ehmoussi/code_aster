! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine hujma2(fami, kpg, ksp, mod, imat,&
                  nmat, tempf, angmas, sigd, vind,&
                  materd, materf, ndt, ndi, nvi,&
                  nr, matcst)
! person_in_charge: alexandre.foucault at edf.fr
    implicit none
!       ----------------------------------------------------------------
!       RECUPERATION DU MATERIAU A TEMPF ET AJUSTEMENT SEUILS
!       IN  MOD    :  TYPE DE MODELISATION
!           IMAT   :  ADRESSE DU MATERIAU CODE
!           NMAT   :  DIMENSION 1 DE MATER
!           TEMPF  :  TEMPERATURE A T + DT
!          ANGMAS  :  ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM - 3CMP)
!           SIGD   :  ETAT CONTRAINTES A T
!           VIND   :  VARIABLE INTERNE A T
!       OUT MATERF :  COEFFICIENTS MATERIAU A T+DT (TEMPF )
!                     MATER(*,I) = CARACTERISTIQUES MATERIAU
!                                    I = 1  CARACTERISTIQUES ELASTIQUES
!                                    I = 2  CARACTERISTIQUES PLASTIQUES
!           MATERD : PARAMETRES MATERIAU A T
!           MATCST :  'OUI' SI  MATERIAU A T = MATERIAU A T+DT
!                     'NON' SINON OU 'NAP' SI NAPPE DANS 'VECMAT.F'
!           NDT    :  NB TOTAL DE COMPOSANTES TENSEURS
!           NDI    :  NB DE COMPOSANTES DIRECTES  TENSEURS
!           NR     :  NB DE COMPOSANTES SYSTEME NL
!           NVI    :  NB DE VARIABLES INTERNES
!       ----------------------------------------------------------------
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterc/r8vide.h"
#include "asterfort/hujcrd.h"
#include "asterfort/hujcri.h"
#include "asterfort/hujmat.h"
#include "asterfort/hujori.h"
#include "asterfort/hujprj.h"
#include "asterfort/utmess.h"
    character(len=8) :: mod
    character(len=3) :: matcst
    character(len=*) :: fami
    integer :: imat, nmat, ndt, ndi, nvi, nr, kpg, ksp
    real(kind=8) :: tempf, materd(nmat, 2), materf(nmat, 2), vind(50)
    real(kind=8) :: sigd(6), angmas(3)
!
    aster_logical :: reorie
    real(kind=8) :: zero, bid66(6, 6), seuil, tin(3), piso, q
    real(kind=8) :: ptrac, b, phi, m, pc0, degr, d, un, trois
    real(kind=8) :: matert(22, 2)
    integer :: i, j
    parameter   ( zero  = 0.d0 )
    parameter   ( un    = 1.d0 )
    parameter   ( trois = 3.d0 )
    parameter   ( degr  = 0.0174532925199d0 )
!     ------------------------------------------------------------------
! ----------------------------------------------------------------------
! ---  NR     :  NB DE COMPOSANTES MAXIMUM DU SYSTEME NL
! ----------------------------------------------------------------------
    nr = 18
!
! ----------------------------------------------------------------------
! ---  RECUPERATION DE MATERF, NDT, NDI, NVI ET MATERD
! ----------------------------------------------------------------------
    matcst = 'OUI'
    call hujmat(fami, kpg, ksp, mod, imat,&
                tempf, matert, ndt, ndi, nvi)
!
    do i = 1, 22
        do j = 1, 2
            materd(i,j) = matert(i,j)
            materf(i,j) = matert(i,j)
        enddo
    end do
!
! ----------------------------------------------------------------------
! --- CONTROLE DE LA DIMENSION DE LA MODELISATION
! --- AJUSTEMENT NECESSAIRE SI MODELISATION TYPE D_PLAN
! ----------------------------------------------------------------------
    if (mod(1:6) .eq. 'D_PLAN') then
        sigd(5) = zero
        sigd(6) = zero
        ndt = 6
    endif
! ----------------------------------------------------------------------
! --- CONTROLE DES EQUILIBRES DE SEUILS PLASTIQUES
! ----------------------------------------------------------------------
! --- 1 ORIENTATION DES CONTRAINTES SELON ANGMAS VERS REPERE LOCAL
    if (angmas(1) .eq. r8vide()) then
        call utmess('F', 'ALGORITH8_20')
    endif
    reorie =(angmas(1).ne.zero) .or. (angmas(2).ne.zero)&
     &         .or. (angmas(3).ne.zero)
    call hujori('LOCAL', 1, reorie, angmas, sigd,&
                bid66)
!
! --- 2 INITIALISATION SEUIL DEVIATOIRE SI NUL
    ptrac = materf(21,2)
    do i = 1, ndi
        if (vind(i) .eq. zero) then
            if (materf(13, 2) .eq. zero) then
                vind(i) = 1.d-3
            else
                vind(i) = materf(13,2)
            endif
!
            call hujcrd(i, matert, sigd, vind, seuil)
!
! --- SI LE SEUIL EST DESEQUILIBRE A L'ETAT INITIAL
!     ON EQUILIBRE LE SEUIL EN CALCULANT LA VALEUR DE R
!     APPROPRIEE
            if (seuil .gt. zero) then
                call hujprj(i, sigd, tin, piso, q)
                piso = piso - ptrac
                b = materf(4,2)
                phi = materf(5,2)
                m = sin(degr*phi)
                pc0 = materf(7,2)
                vind(i) = -q/(m*piso*(un-b*log(piso/pc0)))
                vind(23+i) = un
            endif
        endif
    enddo
!
! ---> 3 INITIALISATION SEUIL ISOTROPE SI NUL
    if (vind(4) .eq. zero) then
        if (materf(14, 2) .eq. zero) then
            vind(4) = 1.d-3
        else
            vind(4) = materf(14,2)
        endif
!
        call hujcri(matert, sigd, vind, seuil)
!
! --- SI LE SEUIL EST DESEQUILIBRE A L'ETAT INITIAL
!     ON EQUILIBRE LE SEUIL EN CALCULANT LA VALEUR DE R
!     APPROPRIEE
!
        if (seuil .gt. zero) then
            piso = (sigd(1)+sigd(2)+sigd(3))/trois
            d = materf(3,2)
            pc0 = materf(7,2)
            vind(4) = piso/(d*pc0)
            if (vind(4) .gt. 1.d0) then
                call utmess('F', 'COMPOR1_83')
            endif
            vind(27)= un
        endif
    endif
!
! ---> 4 INITIALISATION SEUIL CYCLIQUE SI NUL
    do i = 1, ndi
        if (vind(4+i) .eq. zero) then
            if (materf(18, 2) .eq. zero) then
                vind(4+i) = 1.d-3
            else
                vind(4+i) = materf(18,2)
            endif
        endif
    enddo
!
    if (vind(8) .eq. zero) then
        if (materf(19, 2) .eq. zero) then
            vind(8) = 1.d-3
        else
            vind(8) = materf(19,2)
        endif
    endif
!
! --- 5 CONTROLE DES INDICATEURS DE PLASTICITE
    do i = 1, 4
        if (abs(vind(27+i)-un) .lt. r8prem()) vind(23+i)=-un
    enddo
!
! --- 7 ORIENTATION DES CONTRAINTES SELON ANGMAS VERS REPERE GLOBAL
    call hujori('GLOBA', 1, reorie, angmas, sigd,&
                bid66)
!
! ----------------------------------------------------------------------
end subroutine
