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
! person_in_charge: sylvie.granet at edf.fr
! aslint: disable=W1504
!
subroutine calcco(option, yachai, perman, meca, thmc,&
                  ther, hydr, imate, ndim, dimdef,&
                  dimcon, nbvari, yamec, yate, addeme,&
                  adcome, advihy, advico, addep1, adcp11,&
                  adcp12, addep2, adcp21, adcp22, addete,&
                  adcote, congem, congep, vintm, vintp,&
                  dsde, deps, epsv, depsv, p1,&
                  p2, dp1, dp2, temp, dt,&
                  phi, pvp, pad, h11, h12,&
                  kh, rho11, sat,&
                  retcom, carcri, tbiot, vihrho, vicphi,&
                  vicpvp, vicsat, angmas)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/hmgazp.h"
#include "asterfort/hmladg.h"
#include "asterfort/hmlgat.h"
#include "asterfort/hmliga.h"
#include "asterfort/hmlisa.h"
#include "asterfort/hmliva.h"
#include "asterfort/hmlvag.h"
#include "asterfort/hmlvga.h"
#include "asterfort/thmGetParaCoupling.h"
!
real(kind=8), intent(in) :: temp
!
!
! ROUTINE CALCCO : CETTE ROUTINE CALCULE LES CONTRAINTES GENERALISEES
!   ET LA MATRICE TANGENTE DES GRANDEURS COUPLEES, A SAVOIR CELLES QUI
!   NE SONT PAS DES GRANDEURS DE MECANIQUE PURE OU DES FLUX PURS
!   ELLE RENVOIE POUR CELA A DIFFERENTES ROUTINES SUIVANT
!   LA VALEUR DE THMC
! **********************************************************************
! OUT RETCOM : RETOUR LOI DE COMPORTEMENT
! COMMENTAIRE DE NMCONV :
!                       = 0 OK
!                       = 1 ECHEC DANS L'INTEGRATION : PAS DE RESULTAT
!                       = 3 SIZZ NON NUL (DEBORST) ON CONTINUE A ITERER
! ======================================================================
!
    integer :: ndim, dimdef, dimcon, nbvari, imate
    integer :: yamec, yate
    integer :: adcome, adcp11, bdcp11, adcp12, adcp21, adcp22, adcote
    integer :: addeme, addep1, addep2, addete, retcom
    integer :: advihy, advico, vihrho, vicphi, vicpvp, vicsat
    real(kind=8) :: congem(dimcon), congep(dimcon)
    real(kind=8) :: vintm(nbvari), vintp(nbvari)
    real(kind=8) :: dsde(dimcon, dimdef), epsv, depsv, p1, dp1, p2, dp2, dt
    real(kind=8) :: phi, pvp, pad, h11, h12, kh, rho11
    real(kind=8) :: sat, angmas(3)
    character(len=16) :: option, meca, thmc, ther, hydr
    aster_logical :: perman, yachai
! ======================================================================
! --- VARIABLES LOCALES POUR BARCELONE-------------------------------
! ======================================================================
    real(kind=8) :: deps(6), tbiot(6), carcri(*)
!
! INITIALISATION ADRESSE SELON QUE LA PARTIE THH EST TRANSITOIRE OU NON
    if (perman) then
        bdcp11 = adcp11 - 1
    else
        bdcp11 = adcp11
    endif
!
! - Get paremeters for coupling
!
    call thmGetParaCoupling(imate, temp)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_SATU ----------------------
! ======================================================================
    if (thmc .eq. 'LIQU_SATU') then
        call hmlisa(perman, yachai, option, meca,&
                    hydr, imate, ndim, dimdef,&
                    dimcon, nbvari, yamec, yate, addeme,&
                    adcome, advihy, advico, vihrho, vicphi,&
                    addep1, bdcp11, addete, adcote, congem,&
                    congep, vintm, vintp, dsde, epsv,&
                    depsv, p1, dp1, temp, dt,&
                    phi, rho11, sat, retcom,&
                    tbiot, angmas, deps)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE GAZ ----------------------------
! ======================================================================
    else if (thmc.eq.'GAZ') then
        call hmgazp(yachai, option, meca,&
                    hydr, imate, ndim, dimdef, dimcon,&
                    nbvari, yamec, yate, addeme, adcome,&
                    advico, vicphi, addep1, bdcp11, addete,&
                    adcote, congem, congep, vintm, vintp,&
                    dsde, epsv, depsv, p1, dp1,&
                    temp, dt, phi, rho11, &
                    sat, retcom, tbiot,  angmas,&
                    deps)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_VAPE ----------------------
! ======================================================================
    else if (thmc.eq.'LIQU_VAPE') then
        call hmliva(yachai, option, meca, hydr,&
                    imate, ndim, dimdef, dimcon, nbvari,&
                    yamec, yate, advihy,&
                    advico, vihrho, vicphi, vicpvp, vicsat,&
                    addep1, bdcp11, adcp12, addete, adcote,&
                    congem, congep, vintm, vintp, dsde,&
                    epsv, depsv, p1, dp1, temp,&
                    dt, phi, pvp, h11, h12,&
                    rho11, sat, retcom,&
                    tbiot, angmas, deps)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_VAPE_GAZ ------------------
! ======================================================================
    else if (thmc.eq.'LIQU_VAPE_GAZ') then
        call hmlvag(yachai, option, meca, hydr,&
                    imate, ndim, dimdef, dimcon, nbvari,&
                    yamec, yate, addeme, adcome, advihy,&
                    advico, vihrho, vicphi, vicpvp, vicsat,&
                    addep1, bdcp11, adcp12, addep2, adcp21,&
                    addete, adcote, congem, congep, vintm,&
                    vintp, dsde, deps, epsv, depsv,&
                    p1, p2, dp1, dp2, temp,&
                    dt, phi, pvp, h11, h12,&
                    rho11, sat, retcom,&
                    carcri, tbiot, angmas)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_GAZ -----------------------
! ======================================================================
    else if (thmc.eq.'LIQU_GAZ') then
        call hmliga(yachai, option, meca, ther, hydr,&
                    imate, ndim, dimdef, dimcon, nbvari,&
                    yamec, yate, addeme, adcome, advihy,&
                    advico, vihrho, vicphi, vicsat, addep1,&
                    bdcp11, addep2, adcp21, addete, adcote,&
                    congem, congep, vintm, vintp, dsde,&
                    deps, epsv, depsv, p1, p2,&
                    dp1, dp2, temp, dt, phi,&
                    rho11, sat, retcom, thmc,&
                    carcri, tbiot, angmas)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_GAZ_ATM -------------------
! ======================================================================
    else if (thmc.eq.'LIQU_GAZ_ATM') then
        call hmlgat(yachai, option, meca, ther, hydr,&
                    imate, ndim, dimdef, dimcon, nbvari,&
                    yamec, yate, addeme, adcome, advihy,&
                    advico, vihrho, vicphi, vicsat, addep1,&
                    bdcp11, addete, adcote, congem, congep,&
                    vintm, vintp, dsde, epsv, depsv,&
                    p1, dp1, temp, dt, phi,&
                    rho11, sat, retcom, thmc,&
                    tbiot, angmas, deps)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_AD_GAZ_VAPE ---------------
! ======================================================================
    else if (thmc.eq.'LIQU_AD_GAZ_VAPE') then
        call hmlvga(yachai, option, meca, ther, hydr,&
                    imate, ndim, dimdef, dimcon, nbvari,&
                    yamec, yate, addeme, adcome, advihy,&
                    advico, vihrho, vicphi, vicpvp, vicsat,&
                    addep1, bdcp11, adcp12, addep2, adcp21,&
                    adcp22, addete, adcote, congem, congep,&
                    vintm, vintp, dsde, epsv, depsv,&
                    p1, p2, dp1, dp2, temp,&
                    dt, phi, pad, pvp, h11,&
                    h12, kh, rho11, &
                    sat, retcom, thmc, tbiot,&
                    angmas, deps)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_AD_GAZ_VAPE ---------------
! ======================================================================
    else if (thmc.eq.'LIQU_AD_GAZ') then
        call hmladg(yachai, option, meca, ther, hydr,&
                    imate, ndim, dimdef, dimcon, nbvari,&
                    yamec, yate, addeme, adcome, advihy,&
                    advico, vihrho, vicphi, vicpvp, vicsat,&
                    addep1, bdcp11, adcp12, addep2, adcp21,&
                    adcp22, addete, adcote, congem, congep,&
                    vintm, vintp, dsde, epsv, depsv,&
                    p1, p2, dp1, dp2, temp,&
                    dt, phi, pad, h11, h12,&
                    kh, rho11,sat, retcom,&
                    thmc, tbiot, angmas, deps)
! ======================================================================
    endif
! ======================================================================
end subroutine
