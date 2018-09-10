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

subroutine rk5adp(nbeq, param_real, param_int, param_car, t0, dt0, nbmax,&
                  errmax, y0, dy0, rk5fct, resu, iret, ynorme)
    implicit none
#include "asterf_types.h"
#include "asterfort/rk5app.h"
    integer          :: nbeq
    real(kind=8)     :: param_real(*)
    integer          :: param_int(*)
    character(len=*) :: param_car(*)
    real(kind=8)     :: t0
    real(kind=8)     :: dt0
    integer          :: nbmax
    real(kind=8)     :: errmax
    real(kind=8)     :: y0(nbeq)
    real(kind=8)     :: dy0(nbeq)
    real(kind=8)     :: resu(2*nbeq)
    integer          :: iret
    real(kind=8),intent(in),optional :: ynorme(nbeq)
!
    interface
        subroutine rk5fct(ppr, ppi, ppc, yy0, dy0, dyy, decoup)
            real(kind=8)     :: ppr(*)
            integer          :: ppi(*)
            character(len=*) :: ppc(*)
            real(kind=8)     :: yy0(*)
            real(kind=8)     :: dy0(*)
            real(kind=8)     :: dyy(*)
            aster_logical    :: decoup
        end subroutine rk5fct
    end interface
!
! person_in_charge: jean-luc.flejou at edf.fr
! --------------------------------------------------------------------------------------------------
!
!          INTÉGRATION PAR MÉTHODE DE RUNGE KUTTA D'ORDRE 5
!
!  appel à rk5app
!  calcul de l'erreur
!  adaptation du pas de temps
!
! --------------------------------------------------------------------------------------------------
!
!  IN
!     nbeq          : nombre d'équations
!     param_real    : paramètres réels du comportement
!     param_int     : paramètres entier du comportement
!     param_car     : paramètres caractère du comportement
!     t0       : temps
!     dt0      : incrément de temps
!     nbmax    : nombre d'adaptation successive
!     errmax   : erreur pour seuil d'adaptation
!     y0       : valeurs à t
!     dy0      : vitesse à t
!     rkfct    : subroutine du système à intégrer
!
!  OUT
!     resu     : résultat de l'intégration
!        resu(1:nbeq)            : variables intégrées
!        resu(nbeq+1:2*nbeq)     : dérivées a t+dt
!     iret     : redécoupage du pas de temps global
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbbou, ii
    real(kind=8) :: t9, dt9, y9(nbeq), norme(nbeq), erreur, xbid1, solu(3*nbeq)
    aster_logical :: decoup
!
    real(kind=8) :: puplus, pumoin, creduc, cforce, coeffm, seuil, precis, grlog
!   puissance pour augmenter le pas de temps
    parameter (puplus = -0.20d0)
!   puissance pour diminuer le pas de temps
    parameter (pumoin = -0.25d0)
!   coefficient de reduction sur la variation du pas de temps
    parameter (creduc =  0.90d0)
!   coefficient de diminution du pas de temps en cas de forcage
    parameter (cforce =  0.30d0)
!   augmentation maximale de pas de temps
    parameter (coeffm =  5.0d0)
    parameter (seuil  = (coeffm/creduc)**(1.0d0/puplus) )
    parameter (precis =  1.0e-08)
    parameter (grlog  =  1.0e+08)
!
    nbbou = 0
    t9 = t0
    dt9 = dt0
    y9(:) = y0(:)
!   ON COMMENCE
100 continue
!
    if ( present(ynorme) ) then
        norme(:) = ynorme(:)
    else
        norme(:) = y9(:)
        do ii = 1, nbeq
            if (abs(norme(ii)) .le. precis) then
                norme(ii) = 1.0d0
            endif
        enddo
    endif
!   dépassement du nombre d'itération maximum ==> découpage global
    if (nbbou .gt. nbmax) then
        iret = 1
        goto 999
    endif
    decoup = ASTER_FALSE

    call rk5app(nbeq, param_real, param_int, param_car, dt9, y9, dy0, rk5fct, solu, decoup)
    nbbou = nbbou + 1
!   découpage forcé
    if (decoup) then
        dt9 = cforce * dt9
        goto 100
    endif
!   calcul de l'erreur
    erreur = 0.0d0
    do ii = 1, nbeq
        xbid1 = abs( solu(2*nbeq + ii)/norme(ii) )
        if (xbid1 .gt. grlog) then
            if (log10(xbid1) .gt. 100.0d0) then
!               découpage forcé
                dt9 = cforce * dt9
                goto 100
            endif
        endif
        erreur = erreur + (xbid1**2)
    enddo
    erreur = sqrt(erreur)/errmax
    if (erreur .gt. 1.0d0) then
!       on ne converge pas ==> diminution du pas de temps
        xbid1 = creduc * dt9 * (erreur**pumoin)
        dt9 = max(0.10d0 * dt9, xbid1)
        goto 100
    else if (abs(t9 + dt9 - t0 - dt0) .gt. precis) then
!       on a converge ==> augmentation du pas de temps
        nbbou = 0
!       temps convergé
        t9 = t9 + dt9
!       solution convergée
        y9(1:nbeq) = solu(1:nbeq)
!       augmente le pas d'intégration dans la limite de coeffm
        if (erreur .gt. seuil) then
            dt9 = creduc * dt9 * (erreur**puplus)
        else
            dt9 = coeffm * dt9
        endif
!       on ne peut pas dépasser t0 + dt0
        if (t9 + dt9 .gt. t0 + dt0) then
            dt9 = t0 + dt0 - t9
        endif
        goto 100
    endif
!   résultat
    resu = solu(1:2*nbeq)
999 continue
end subroutine
