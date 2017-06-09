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

subroutine lkgamp(val, varv, im, sm, ucrip,&
                  seuilp, vinm, nbmat, mater, de,&
                  deps, depsv, dgamv, depsp, dgamp,&
                  retcom)
!
    implicit    none
#include "asterfort/lcdevi.h"
#include "asterfort/lkbpri.h"
#include "asterfort/lkcalg.h"
#include "asterfort/lkcaln.h"
#include "asterfort/lkdfds.h"
#include "asterfort/lkdhds.h"
#include "asterfort/lkdlam.h"
#include "asterfort/lkds2h.h"
#include "asterfort/lkvacp.h"
#include "asterfort/lkvarp.h"
    integer :: nbmat, val, varv, retcom
    real(kind=8) :: im, sm(6), mater(nbmat, 2), vinm(7)
    real(kind=8) :: depsp(6), deps(6), depsv(6)
    real(kind=8) :: dgamp, dgamv, de(6, 6)
    real(kind=8) :: ucrip, seuilp
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE--------------------------
! =================================================================
! --- BUT : LA DEFORMATION ELASTOPLASTIQUE ET LE CALCUL DE DGAMMAP
! =================================================================
! IN  : VAL   : INDICATEUR POUR DISTINGUER LES LOIS DE DILATANCE --
! --- : VARV  : INDICATEUR CONTRACTANCE OU DILATANCE --------------
! --- : IM    :  INVARIANT DES CONTRAINTES A T---------------------
! --- : SM    :  DEVIATEUR DES CONTRAINTES A T---------------------
! --- : UCRIP :  VALEUR DE U POUR LES CONTRAINTES A L INSTANT MOINS
! --- : SEUILP:  VALEUR DU SEUIL PLASTIAQUE A L INSTANT MOINS -----
! --  : VINM   :  VARIABLES INTERNES ------------------------------
! --- : NBMAT :  NOMBRE DE PARAMETRES MATERIAU --------------------
! --- : MATER :  COEFFICIENTS MATERIAU A T+DT ---------------------
! ----------- :  MATER(*,1) = CARACTERISTIQUES ELASTIQUES ---------
! ----------- :  MATER(*,2) = CARACTERISTIQUES PLASTIQUES ---------
! --- : DE    :  MATRICE ELASTIQUE --------------------------------
!-------DEPS  :  INCREMENT DEFORMATIONS TOTALES
! --- : DEPSV :  ACCROISSEMENT DES DEFORMATIONS VISCOPLASTIQUE A T
! --- : DGAMV :  ACCROISSEMENT DE GAMMA VISCOPLASTIQUE ------------
! OUT : DEPSP : DEFORMATIONS PLASTIQUES ---------------------------
!     : DGAMP : PARAMETRE D ECROUISSAGE PLASTIQUES-----------------
! ----: RETCOM: CODE RETOUR POUR REDECOUPAGE DU PAS DE TEMPS ------
! =================================================================
    common /tdim/   ndt , ndi
    integer :: i, ndi, ndt
    real(kind=8) :: deux, trois
    real(kind=8) :: paraep(3), varpl(4)
    real(kind=8) :: dhds(6), ds2hds(6), dfdsp(6), ddepsp(6)
    real(kind=8) :: vecnp(6), gp(6)
    real(kind=8) :: bprimp, dlam, devgii
! =================================================================
! --- INITIALISATION DE PARAMETRES --------------------------------
! =================================================================
    parameter       ( deux    =  2.0d0   )
    parameter       ( trois   =  3.0d0   )
! =================================================================
! --- CALCUL DE DF/DSIG ------------------------------------
! =================================================================
!
    call lkdhds(nbmat, mater, im, sm, dhds,&
                retcom)
    call lkds2h(nbmat, mater, im, sm, dhds,&
                ds2hds, retcom)
    call lkvarp(vinm, nbmat, mater, paraep)
!
    call lkvacp(nbmat, mater, paraep, varpl)
!
    call lkdfds(nbmat, mater, sm, paraep, varpl,&
                ds2hds, ucrip, dfdsp)
!
! =================================================================
! --- CALCUL DE G -------------------------------------------------
! =================================================================
!
    bprimp = lkbpri (val,vinm,nbmat,mater,paraep,im,sm)
!
    call lkcaln(sm, bprimp, vecnp, retcom)
!
    call lkcalg(dfdsp, vecnp, gp, devgii)
! =================================================================
! --- CALCUL DE D LAMBDA ------------------------------------
! =================================================================
    call lkdlam(varv, nbmat, mater, deps, depsv,&
                dgamv, im, sm, vinm, de,&
                ucrip, seuilp, gp, devgii, paraep,&
                varpl, dfdsp, dlam)
!
! =================================================================
! --- CALCUL DE DEDEV --------DEVIATEUR DU TENSEUR DES DEFORMATIONS
! =================================================================
!
    do 10 i = 1, ndt
        depsp(i) = dlam*gp(i)
10  end do
    call lcdevi(depsp, ddepsp)
! =================================================================
! --- CALCUL DE DGAMP ------------------------------------
! =================================================================
!
    dgamp = 0.d0
!
    do 20 i = 1, ndt
        dgamp = dgamp + ddepsp(i)**2
20  end do
    dgamp = sqrt(deux/trois * dgamp)
! =================================================================
end subroutine
