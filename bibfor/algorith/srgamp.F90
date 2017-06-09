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

subroutine srgamp(val, varv, im, sm, ucrip,&
                  seuilp, vinm, nvi, nbmat, mater, de,&
                  deps, depsv, dgamv, depsp, dgamp, retcom)

!

!!!
!!! MODELE LKR : CALCUL DE DEPSP ET DE DGAMP
!!!

! ===================================================================================
! IN  : VAL            : INDICATEUR POUR DISTINGUER LES LOIS DE DILATANCE
!     : VARV           : INDICATEUR CONTRACTANCE OU DILATANCE
!     : IM             : INVARIANT DES CONTRAINTES A T
!     : SM(6)          : DEVIATEUR DES CONTRAINTES A T
!     : UCRIP          : VALEUR DE U POUR LES CONTRAINTES A L INSTANT MOINS
!     : SEUILP         : VALEUR DU SEUIL PLASTIQUE A L INSTANT MOINS
!     : VINM(NVI)      : VARIABLES INTERNES
!     : NVI            : NOMBRE DE VARIABLES INTERNES
!     : NBMAT          : NOMBRE DE PARAMETRES MATERIAU
!     : MATER(NBMAT,2) : COEFFICIENTS MATERIAU A T + DT
!                           MATER(*,1) = CARACTERISTIQUES ELASTIQUES
!                           MATER(*,2) = CARACTERISTIQUES PLASTIQUES
!     : DE(6,6)        : MATRICE ELASTIQUE
!     : DEPS(6)        : INCREMENT DEFORMATIONS TOTALES
!     : DEPSV(6)       : ACCROISSEMENT DES DEFORMATIONS VISCOPLASTIQUES A T
!     : DGAMV          : ACCROISSEMENT DE GAMMVP
! OUT : DEPSP(6)       : DEFORMATIONS PLASTIQUES
!     : DGAMP          : VARIABLE D ECROUISSAGE PLASTIQUES
!     : RETCOM         : CODE RETOUR POUR REDECOUPAGE DU PAS DE TEMPS
! ===================================================================================

    implicit    none

#include "asterfort/lcdevi.h"
#include "asterfort/srbpri.h"
#include "asterfort/srcalg.h"
#include "asterfort/srcaln.h"
#include "asterfort/srdfds.h"
#include "asterfort/srdhds.h"
#include "asterfort/srdlam.h"
#include "asterfort/srds2h.h"
#include "asterfort/srvacp.h"
#include "asterfort/srvarp.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: nbmat,val,varv,retcom,nvi
    real(kind=8) :: im,sm(6),mater(nbmat,2),vinm(nvi),depsp(6),deps(6),depsv(6)
    real(kind=8) :: dgamp,dgamv,de(6,6),ucrip,seuilp
    
    !!!
    !!! Variables locales
    !!!
    
    integer :: i,ndi,ndt
    real(kind=8) :: paraep(3),varpl(4),dhds(6),ds2hds(6), dfdsp(6), ddepsp(6)
    real(kind=8) :: vecnp(6),gp(6),bprimp,dlam,devgii,tmm
    common /tdim/ ndt,ndi
    
    !!!
    !!! Recuperation des temperatures et des increments
    !!!
    
    tmm=mater(6,1)
    
    !!!
    !!! Calcul de dfp/dsig
    !!!
    
    call srdhds(nbmat,mater,sm,dhds,retcom)
    call srds2h(nbmat,mater,sm,dhds,ds2hds,retcom)
    call srvarp(vinm,nvi,nbmat,mater,tmm,paraep)
    call srvacp(nbmat,mater,paraep,varpl)
    call srdfds(nbmat,mater,paraep,varpl,ds2hds,ucrip,dfdsp)
    
    !!!
    !!! Calcul de gp
    !!!
    
    bprimp=srbpri(val,vinm,nvi,nbmat,mater,paraep,im,sm,tmm)
    call srcaln(sm,bprimp,vecnp,retcom)
    call srcalg(dfdsp,vecnp,gp,devgii)
    
    !!!
    !!! Calcul de dlambda
    !!!
    
    call srdlam(varv,nbmat,mater,deps,depsv,dgamv,im,sm,vinm,nvi,de,&
                ucrip,seuilp,gp,devgii,paraep,varpl,dfdsp,dlam)

    !!!
    !!! Calcul de dgamp
    !!!
    
    do i=1,ndt
        depsp(i)=dlam*gp(i)
    end do
    
    call lcdevi(depsp,ddepsp)
    
    dgamp=0.d0
    
    do i=1, ndt
        dgamp=dgamp+ddepsp(i)**2.d0
    end do
    
    dgamp=sqrt(2.d0/3.d0*dgamp)

end subroutine
