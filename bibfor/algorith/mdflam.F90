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

subroutine mdflam(dnorm, vitloc, knorm, cnorm, cost, sint,&
                  flim, fseuil, rigifl, defpla, fnorma,&
                  flocal, vnorm, defmax, enfo_fl, def,&
                  deft0, deft)
    implicit none
!


#include "asterfort/utmess.h"


!***********************************************************************
! 01/01/91    G.JACQUART AMV/P61 47 65 49 41
!***********************************************************************
!     FONCTION  : CALCULE LA DISTANCE NORMALE A L'OBSTACLE (<0 SI CHOC)
!
!-----------------------------------------------------------------------
!                             ARGUMENTS
! .________________.____.______________________________________________.
!    DNORM          <--   DISTANCE NORMALE A L'OBSTACLE
!    VITLOC         <--   VITESSE DANS LE REPERE LOCAL
!    COST,SINT      <--   DIRECTION NORMALE A L'OBSTACLE
!    KNORM          <--   RAIDEUR NORMALE DE CHOC
!    CNORM          <--   RAIDEUR NORMALE DE CHOC
!    FLIM           <--   EFFORT MAXIMAL DE CHOC 
!    FSEUIL         <--   EFFORT MAXIMAL DE CHOC POST FLAMBAGE
!    RIGIFL         <--   RAIDEUR NORMALE DE CHOC POST FLAMBAGE
!    DEFPLA         <--   DEFORMATION PLASTIQUE
!    DEFMAX         <--   DEFORMATION TOTALE MAXIMALE
!    ENFO_FL        <--   ENFONCEMENT AU FLAMBAGE
!    DEF            <--   LISTE DE DEFORMATIONS PLASTIQUES POST FLAMBAGE
!    DEFT0          <--   DEFORMATION TOTALE A LA FIN DU PLATEAU
!    DEFT           <--   LISTE DE DEFORMATIONS TOTALES POST FLAMBAGE
!    FNORMA          -->  FORCE NORMALE DE CHOC  (MODULE)
!    FLOCAL          -->  FORCE NORMALE DE CHOC REP. LOCAL
!-----------------------------------------------------------------------
    real(kind=8) :: vitloc(3), flocal(3), knorm, fnorma
!-----------------------------------------------------------------------
    real(kind=8) :: cost, defpla, dnorm, flim, fseuil, rigifl, sint
    real(kind=8) :: vnorm, enfo_fl, defmax, cnorm, deft0
    real(kind=8) :: alpha
    integer :: j

    real(kind=8)     , pointer  :: def(:)                
    real(kind=8)     , pointer  :: deft(:)           


!-----------------------------------------------------------------------

    vnorm = vitloc(2)*cost + vitloc(3)*sint
    
!
    if (defpla .le. 0.d0) then
!     --- FLAMBAGE NON ENCORE RENCONTRE ---
        if (-dnorm .lt. 0.d0) then
            fnorma = 0.0d0
           else
            if (-dnorm .lt. (flim+cnorm*vnorm)/knorm) then 
                fnorma = -knorm*dnorm  - cnorm*vnorm
        if (fnorma .lt. 0.d0) fnorma = 0.d0
               else
!           --- DEBUT DU FLAMBAGE ---
                fnorma = flim
                defpla = 1.d-20
                rigifl = knorm
            endif
        endif
    else
!     --- LE FLAMBAGE A DEJA EU LIEU --- vnorm - a la charge puis + a la decharge
!     --- Si charge inferieure au jeu mis a jour
        if (-dnorm .lt. defpla) then
            fnorma = 0.0d0
        else
!     --- Si decharge ou charge inferieure a la limite
            if ( vnorm .gt. 0.d0 .or. -dnorm .le. defmax) then 
                fnorma = -rigifl*(dnorm+defpla)  - cnorm*vnorm
                if ((defmax .lt. deft0) .and.(fnorma .ge. flim))  then
                        fnorma=flim 
                else if ((fnorma .ge. flim+((fseuil-flim)/enfo_fl)*(defmax-deft0)) &
                    .and.(defmax .lt. deft(1))) then 
                        fnorma = flim+((fseuil-flim)/enfo_fl)*(defmax-deft0) 
                else if (fnorma .ge. fseuil) then 
                        fnorma=fseuil 
                endif
                if (fnorma .lt. 0.d0) fnorma = 0.d0
            else
!     --- Deformation pendant le plateau
                if (-dnorm .lt. deft0) then
                     fnorma = flim
                     defpla = -dnorm - flim/rigifl
                endif
!     --- Deformation pendant le flambage
                if ((-dnorm.ge.deft0).and.(-dnorm.lt.deft(1))) then
                     fnorma = flim-((fseuil-flim)/enfo_fl)*(dnorm+deft0)
                     rigifl = fnorma/(-dnorm-defpla)   
                     defpla = def(1)
                endif
!     --- Deformation post flambage
                if (-dnorm .ge. deft(1) .and. (size(def) .lt. 2)) then
                fnorma = fseuil
                rigifl = fseuil/(deft(1)-def(1))
                defpla = -dnorm-fseuil/rigifl
                else
                  do j= 1,(size(def)-1)
                     if (-dnorm .ge. deft(j) .and. -dnorm .lt. deft(j+1)) then
                           fnorma = fseuil  
                           alpha  = (-dnorm-deft(j))/(deft(j+1)-deft(j))
                           defpla = def(j)+alpha*(def(j+1)-def(j))
                           rigifl = fseuil/(-dnorm-defpla)
                     endif
                  enddo
                  if (-dnorm.gt.deft(size(deft))) then
                     fnorma = fseuil
                     rigifl=fseuil/(deft(size(deft))-def(size(def)))
                     defpla = -dnorm-fseuil/rigifl
                     call utmess('A', 'ALGORITH5_86')
                  endif
                endif
            endif
        endif
    endif

    if (-dnorm .gt. defmax) then
        defmax=-dnorm
    endif    
    flocal(1)=0.d0
    flocal(2)=fnorma*cost
    flocal(3)=fnorma*sint
end subroutine

