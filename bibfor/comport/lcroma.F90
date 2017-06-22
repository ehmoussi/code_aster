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

subroutine lcroma(fami, kpg, ksp, poum, mate)
!
!
    implicit none
#include "asterfort/rcfonc.h"
#include "asterfort/rctrac.h"
#include "asterfort/rctype.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
    integer :: kpg, ksp, mate
    character(len=*) :: fami, poum
!
! ******************************************************
! *       INTEGRATION DE LA LOI DE ROUSSELIER LOCAL    *
! *        LECTURE DES CARACTERISTIQUES DU MATERIAU    *
! ******************************************************
!
! IN  MATE    : ADRESSE DU MATERIAU
! IN  TEMP    : TEMPERATURE A L'INSTANT DU CALCUL
! IN COMMON   : PM DOIT DEJA ETRE AFFECTE (PLASTICITE CUMULEE EN T-)
! ----------------------------------------------------------------------
!  COMMON LOI DE COMPORTEMENT ROUSSELIER
!
    integer :: itemax, jprolp, jvalep, nbvalp, iret
    real(kind=8) :: prec, young, nu, sigy, sig1, rousd, f0, fcr, acce
    real(kind=8) :: pm, rpm, fonc, fcd, dfcddj, dpmaxi,typoro
    common /lcrou/ prec,young,nu,sigy,sig1,rousd,f0,fcr,acce,&
     &               pm,rpm,fonc,fcd,dfcddj,dpmaxi,typoro,&
     &               itemax, jprolp, jvalep, nbvalp
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    integer :: icodre(7)
    character(len=8) :: para_type
    character(len=16) :: nomres(7)
    real(kind=8) ::  valres(7), pente, aire, temp, para_vale, val(1)
! ----------------------------------------------------------------------
!
!
!
! 1 - CARACTERISTIQUE ELASTIQUE E ET NU => CALCUL DE MU - K
!
    call rcvalb(fami, kpg, ksp, poum, mate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                1, 'NU', val, icodre(1), 2)
    nu=val(1)            
    call rcvarc(' ', 'TEMP', poum, fami, kpg, ksp, temp, iret)
    call rctype(mate, 1, 'TEMP', [temp], para_vale, para_type)
    if ((para_type.eq.'TEMP') .and. (iret.eq.1)) then
        call utmess('F', 'COMPOR5_5', sk = para_type)
    endif
    call rctrac(mate, 1, 'SIGM', para_vale, jprolp,&
                jvalep, nbvalp, young)
!
!
! 2 - SIGY ET ECROUISSAGE EN P-
!
    call rcfonc('S', 1, jprolp, jvalep, nbvalp,&
                sigy = sigy)
!
    call rcfonc('V', 1, jprolp, jvalep, nbvalp,&
                p = pm, rp = rpm, rprim = pente, airerp = aire)
!
!
! 3 - PARAMETRES DE CROISSANCE DE CAVITES ET CONTROLE INCR. PLASTIQUE
!
    nomres(1) = 'D'
    nomres(2) = 'SIGM_1'
    nomres(3) = 'PORO_INIT'
    nomres(4) = 'PORO_CRIT'
    nomres(5) = 'PORO_ACCE'
    nomres(6) = 'DP_MAXI'
    nomres(7) = 'PORO_TYPE'
!
    call rcvalb(fami, kpg, ksp, poum, mate,&
                ' ', 'ROUSSELIER', 0, ' ', [0.d0],&
                7, nomres, valres, icodre, 2)
    rousd = valres(1)
    sig1 = valres(2)
    f0 = valres(3)
    fcr = valres(4)
    acce = valres(5)
    dpmaxi= valres(6)
    typoro = valres(7)
!
end subroutine
