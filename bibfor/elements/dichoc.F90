! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine dichoc(nbt, neq, nno, nc, icodma,&
                  dul, utl, xg, pgl, klv,&
                  duly, dvl, dpe, dve, force,&
                  varmo, varpl, dimele)
!
! ----------------------------------------------------------------------
!
!     RELATION DE COMPORTEMENT "DIS_CHOC"
!
! ----------------------------------------------------------------------
!
! IN  :  NBT    : NOMBRE DE VALEURS POUR LA DEMI-MATRICE
!        NEQ    : NOMBRE DE DDL DE L'ELEMENT
!        ICODMA : ADRESSE DU MATERIAU CODE
!        DUL    : INCREMENT DE DEPLACEMENT REPERE LOCAL
!        UTL    : DEPLACEMENT COURANT REPERE LOCAL
!        DIMELE : DIMENSION DE L'ELEMENT
!
! OUT :  KLV    : MATRICE TANGENTE
!        DULY   :
!
! ----------------------------------------------------------------------
!
    implicit none
#include "asterc/r8prem.h"
#include "asterfort/rcvala.h"
#include "asterfort/ut2vgl.h"
#include "asterfort/utpvgl.h"
#include "blas/dcopy.h"
!
    integer :: nbt, neq, nno, nc, icodma, dimele, i
    real(kind=8) :: dul(neq), utl(neq), dvl(neq)
    real(kind=8) :: dpe(neq), dve(neq)
    real(kind=8) :: klv(nbt), duly, xg(6), pgl(3, 3)
    real(kind=8) :: varmo(8), varpl(8), force(3)
! ----------------------------------------------------------------------
!
    integer, parameter  :: nbre1=8
    real(kind=8)        :: valre1(nbre1)
    integer             :: codre1(nbre1)
    character(len=8)    :: nomre1(nbre1)
!
    real(kind=8) :: xl(6), xd(3), dirl(6), rignor, rigtan
    real(kind=8) :: coulom, dist12, utot, vit2, vit3, depx, depy, depz, psca
    real(kind=8) :: vitt, vity, vitz, fort, kty
!
    data nomre1 /'RIGI_NOR','RIGI_TAN','AMOR_NOR','AMOR_TAN', &
                 'COULOMB','DIST_1','DIST_2','JEU'/
! ----------------------------------------------------------------------
!
! --- DEFINITION DES PARAMETRES
    xl = 0.d0 ; dirl = 0.d0 ; xd = 0.d0
!   COORDONNEES DANS LE REPERE LOCAL
    if (dimele .eq. 3) then
        call utpvgl(nno, 3, pgl, xg, xl)
    else if (dimele.eq.2) then
        call ut2vgl(nno, 2, pgl, xg, xl)
    endif
!
    valre1(:) = 0.0
!   CARACTERISTIQUES DU MATERIAU
!       SI MOT_CLE RIGI_NOR ==> RIGNOR = VALRE1(1)
!       SINON               ==> RIGNOR = KLV(1)
    call rcvala(icodma, ' ', 'DIS_CONTACT', 0, ' ',&
                [0.0d0], nbre1, nomre1, valre1, codre1, 0, nan='NON')
    if (codre1(1) .eq. 0) then
        rignor = valre1(1)
    else
        rignor = klv(1)
    endif
    if ( codre1(2) .eq. 0) then
        rigtan = valre1(2)
    else
        rigtan = 0.0
    endif
!        AMONOR = VALRE1(3)
!        AMOTAN = VALRE1(4)
    coulom = valre1(5)
!
!   ELEMENT A 2 NOEUDS
    if (nno .eq. 2) then
        dist12 = valre1(6)+valre1(7)
!       DANS L'AXE DU DISCRET
        duly = dul(1+nc)-dul(1)
        utot = utl(1+nc)-utl(1)
!       VITESSE TANGENTE
        vit2 = dvl(2+nc)-dvl(2)
        vit3 = 0.0
        if (dimele .eq. 3) then
            vit3 = dvl(3+nc)-dvl(3)
        endif
!       LONGUEUR DU DISCRET
        do i = 1, dimele
            xd(i) = xl(dimele+i) - xl(i)
        end do
        call dcopy(dimele, dpe(1), 1, dirl, 1)
        call dcopy(dimele, dpe(1+nc), 1, dirl(4), 1)
        depx = xd(1) - dist12 + utot + dirl(4) - dirl(1)
        depx = depx - r8prem()
        depy = xd(2) + utl(2+nc) - utl(2) + dirl(5) - dirl(2)
        depz = 0.0
        if (dimele .eq. 3) then
            depz = xd(3) + utl(3+nc) - utl(3) + dirl(6) - dirl(3)
        endif
        call dcopy(dimele, dve(1), 1, dirl, 1)
        call dcopy(dimele, dve(1+nc), 1, dirl(4), 1)
!       VITESSE TANGENTE
        vity = vit2 + dirl(5) - dirl(2)
        vitz = 0.0
        if (dimele .eq. 3) then
            vitz = vit3 + dirl(6) - dirl(3)
        endif
        if (depx .le. 0.0) then
            kty      = rignor
            force(1) = rignor*depx
            if (force(1) .gt. 0.0) force(1) = 0.0
            psca = varmo(5)*vity + varmo(6)*vitz
            if (psca .ge. 0.0d0 .and. varmo(7) .eq. 1.0d0) then
                vitt = (vity**2 + vitz**2)**0.5d0
                force(2) = 0.0
                force(3) = 0.0
                if (vitt .ne. 0.0d0) then
                    force(2) = -coulom*force(1)*vity/vitt
                    force(3) = -coulom*force(1)*vitz/vitt
                endif
                varpl(7) = 1.d0
            else
                force(2) = rigtan*(depy-varmo(1)) + varmo(5)
                force(3) = rigtan*(depz-varmo(2)) + varmo(6)
                varpl(7) = 0.0
                fort = (force(2)**2 + force(3)**2)**0.5d0
                if (fort .gt. abs(coulom*force(1))) then
                    vitt = (vity**2 + vitz**2)**0.5d0
                    force(2) = 0.0
                    force(3) = 0.0
                    if (vitt .ne. 0.0d0) then
                        force(2) = -coulom*force(1)*vity/vitt
                        force(3) = -coulom*force(1)*vitz/vitt
                        varpl(7) = 1.d0
                    endif
                endif
            endif
            varpl(5) = force(2)
            varpl(6) = force(3)
            force(2) = force(2) + klv(3)*(utl(2+nc)-utl(2))
            if (dimele .eq. 3) then
                force(3) = force(3) + klv(6)*(utl(3+nc)-utl(3))
            endif
            if (dimele .eq. 3) then
                if (neq .eq. 6) then
                    klv( 1) = kty
                    klv( 7) = -kty
                    klv(10) = kty
                else if (neq.eq.12) then
                    klv( 1) = kty
                    klv(22) = -kty
                    klv(28) = kty
                endif
            else
                if (neq .eq. 4) then
                    klv( 1) = kty
                    klv( 4) = -kty
                    klv( 6) = kty
                else if (neq.eq.6) then
                    klv( 1) = kty
                    klv( 7) = -kty
                    klv(10) = kty
                endif
            endif
        else
            kty = 0.0
            force(1) = 0.0
            force(2) = 0.0
            force(3) = 0.0
            varpl(5) = 0.0
            varpl(6) = 0.0
            varpl(7) = 0.0
            klv(1:nbt)= 0.0
        endif
        varpl(1) = depy
        varpl(2) = depz
        varpl(3) = vity
        varpl(4) = vitz
        varpl(8) = depx
!
!   ELEMENT A 1 NOEUD
    else
        dist12 = valre1(8) - valre1(6)
!       DANS L'AXE DU DISCRET
        duly = dul(1)
!       VITESSE TANGENTE
        vit2 = dvl(2)
        vit3 = 0.0
        if (dimele .eq. 3) then
            vit3 = dvl(3)
        endif
!       LONGUEUR DU DISCRET
        call dcopy(dimele, dpe(1), 1, dirl, 1)
        depx = utl(1) + dist12 + dirl(1)
        depy = utl(2) + dirl(2)
        depz = 0.0
        if (dimele .eq. 3) then
            depz = utl(3) + dirl(3)
        endif
        call dcopy(dimele, dve(1), 1, dirl, 1)
!       VITESSE TANGENTE
        vity = vit2 + dirl(2)
        vitz = 0.0
        if (dimele .eq. 3) then
            vitz = vit3 + dirl(3)
        endif
        if (depx .le. 0.0d0) then
            kty      = rignor
            force(1) = rignor*depx
            if (force(1) .gt. 0.0) force(1) = 0.0
            psca = varmo(5)*vity + varmo(6)*vitz
            if (psca .ge. 0.0d0 .and. varmo(7) .eq. 1.d0) then
                vitt = (vity**2 + vitz**2)**0.5d0
                force(2) = 0.0
                force(3) = 0.0
                if (vitt .ne. 0.0) then
                    force(2) = -coulom*force(1)*vity/vitt
                    force(3) = -coulom*force(1)*vitz/vitt
                endif
                varpl(7) = 1.d0
            else
                force(2) = rigtan*(depy-varmo(1)) + varmo(5)
                force(3) = rigtan*(depz-varmo(2)) + varmo(6)
                varpl(7) = 0.0
                fort = (force(2)**2 + force(3)**2)**0.5d0
                if (fort .gt. abs(coulom*force(1))) then
                    vitt = (vity**2 + vitz**2)**0.5d0
                    force(2) = 0.0
                    force(3) = 0.0
                    if (vitt .ne. 0.0d0) then
                        force(2) = -coulom*force(1)*vity/vitt
                        force(3) = -coulom*force(1)*vitz/vitt
                        varpl(7) = 1.d0
                    endif
                endif
            endif
            varpl(5) = force(2)
            varpl(6) = force(3)
            force(2) = force(2) + klv(3)*utl(2)
            if (dimele .eq. 3) force(3) = force(3) + klv(6)*utl(3)
            klv(1) = kty
        else
            kty = 0.0
            force(1) = 0.0
            force(2) = 0.0
            force(3) = 0.0
            varpl(5) = 0.0
            varpl(6) = 0.0
            varpl(7) = 0.0
            klv(1:nbt)= 0.0
        endif
        varpl(1) = depy
        varpl(2) = depz
        varpl(3) = vity
        varpl(4) = vitz
        varpl(8) = depx
    endif
!
end subroutine
