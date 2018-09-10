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

subroutine hydrvari(vari0,vari1,hydra0,hydra1,hydras)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   effets de l hydratation sur les varibles internes
!   declaration externes
    implicit none
      real(kind=8) :: vari0,vari1,hydra0,hydra1,hydras
      integer erreur   
!   varibles locales
      real(kind=8) :: yymin
      parameter (yymin=1.d-3)
!   initialisation controle d erreur      
      erreur=0
      if (hydra1.lt. yymin) then
!    le materiau est non coherent les varibles internes
!    sont conservees inchangées         
       vari1=0.d0
      else
       hydra1=dmin1(hydra1,1.d0)
       if ((hydra1.ge.hydra0).and.(hydra0.gt.hydras)) then
!      apres le seuil on conserve les vari ou on les attenue          
         vari1=vari0*(hydra0-hydras)/(hydra1-hydras)
       else
         if (hydra1.le.hydras) then
!       avant le seuil on et les vari  a zero         
          vari1=0.d0
         else
!       la fin de pas a passé le seuil mais pas le debut de pas
!       ou bien l hydratation diminue         
          vari1=vari0
         end if          
       end if
      end if
end subroutine
