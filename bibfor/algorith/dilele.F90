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
! aslint: disable=W1306,W1504
!
subroutine dilele(npi, ndim, dimuel,&
                  nddls, nddlm, nno, nnos, nnom,&
                  axi, regula, dimcon, ipoids, ipoid2,&
                  ivf, ivf2, interp, idfde, idfde2,&
                  compor, geom, deplp, contp, imate,&
                  dimdef, matuu, vectu, lVect, lMatr, lSigm,&
                  codret)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cabrp0.h"
#include "asterfort/cabrp1.h"
#include "asterfort/cabrsl.h"
#include "asterfort/dilopt.h"
#include "asterfort/dilpen.h"
#include "asterfort/dilsga.h"
#include "asterfort/equdil.h"
!
aster_logical :: axi
integer :: npi, ipoids, ipoid2, ivf, ivf2, idfde, idfde2, nddls, nddlm
integer :: imate, dimdef, ndim, nno, nnom, nnos, dimuel, dimcon
integer :: regula(6)
real(kind=8) :: vectu(dimuel), matuu(dimuel*dimuel), contp(dimcon*npi)
real(kind=8) :: geom(ndim, *), deplp(dimuel)
character(len=2) :: interp
character(len=16) :: compor(*)
aster_logical, intent(in) :: lVect, lMatr, lSigm
integer, intent(out) :: codret
! ======================================================================
! --- BUT : CALCUL ELEMENTAIRE DE LA PARTIE SECOND GRADIENT A ----------
! ---       MICRO-DILATATION AUX POINTS D'INTEGRATION ------------------
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, n, kpg, iDime
    real(kind=8) :: b(dimdef, dimuel), poids, poids2, r(dimdef), rpena
    real(kind=8) :: defgep(dimdef), drde(dimcon, dimdef)
    real(kind=8) :: sigp(dimcon)
! ======================================================================
! --- INITIALISATION DE VECTU, MATUU A 0 SUIVANT OPTION ----------------
! ======================================================================
    rpena = 0.0d0
! ======================================================================
    codret = 0
    if (lMatr) then
        do i = 1, dimuel*dimuel
            matuu(i)=0.d0
        end do
    endif
    if (lVect) then
        do i = 1, dimuel
            vectu(i)=0.d0
        end do
    endif
! ======================================================================
! --- RECUPERATION DU COEFFICIENT DE PENALISATION ----------------------
! ======================================================================
    call dilpen(imate, rpena)
! ======================================================================
! --- BOUCLE SUR LES POINTS D'INTEGRATION ------------------------------
! ======================================================================
    do kpg = 1, npi
! ======================================================================
! --- DEFINITION DE L'OPERATEUR B (DEFINI PAR E=B.U) -------------------
! ======================================================================
        if (interp .eq. 'P0') then
            call cabrp0(kpg, ipoids, ipoid2, ivf, ivf2,&
                        idfde, idfde2, geom, dimdef, dimuel,&
                        ndim, nddls, nddlm, nno, nnos,&
                        nnom, axi, regula, b, poids,&
                        poids2)
        else if (interp.eq.'SL') then
            call cabrsl(kpg, ipoids, ipoid2, ivf, ivf2,&
                        idfde, idfde2, geom, dimdef, dimuel,&
                        ndim, nddls, nddlm, nno, nnos,&
                        nnom, axi, regula, b, poids,&
                        poids2)
        else if (interp.eq.'P1') then
            call cabrp1(kpg, ipoids, ipoid2, ivf, ivf2,&
                        idfde, idfde2, geom, dimdef, dimuel,&
                        ndim, nddls, nddlm, nno, nnos,&
                        nnom, axi, regula, b, poids,&
                        poids2)
        endif
! ======================================================================
! --- CALCUL DES DEFORMATIONS GENERALISEES E=B.U -----------------------
! ======================================================================
        do i = 1, dimdef
            defgep(i) = 0.d0
            do n = 1, dimuel
                defgep(i) = defgep(i)+b(i,n)*deplp(n)
            end do
        end do
! ======================================================================
! --- CALCUL DES CONTRAINTES VIRTUELLES ET GENERALISEES ----------------
! --- ET DE LEURS DERIVEES ---------------------------------------------
! ======================================================================
        call equdil(imate, lSigm, compor, regula, dimdef,&
                    dimcon, defgep, interp, ndim, sigp  ,&
                    rpena, r, drde)
        if (lSigm) then
            do iDime = 1, dimcon
                contp(dimcon*(kpg-1) + iDime) = sigp(iDIme)
            end do
        endif
        if (lMatr) then
            call dilopt(dimdef, dimuel, poids, poids2, b,&
                        drde, matuu)
        endif
        if (lVect) then
            call dilsga(dimdef, dimuel, poids, poids2, b,&
                        r, vectu)
        endif
    end do
!
end subroutine
