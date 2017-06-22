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

!
!
interface
subroutine nocart(carte, code, ncmp, groupma, mode, nma,&
                  limano, limanu, ligrel,&
                  rapide,jdesc,jnoma,jncmp,jnoli,jvale,&
                  jvalv,jnocmp,ncmpmx,nec, ctype,&
                  jlima0,jlimac,lontav)

    character(len=*), intent(in) :: carte
    integer, intent(in) :: code
    integer, intent(in) :: ncmp
    character(len=*), intent(in), optional :: groupma
    character(len=*),intent(in), optional :: mode
    integer, intent(in), optional :: nma
    character(len=*), intent(in), optional :: limano(*)
    integer, intent(in), optional :: limanu(*)
    character(len=*), intent(in), optional ::  ligrel

!   -- arguments optionnels pour gagner du CPU :
    character(len=3), intent(in), optional ::  rapide
    integer, intent(inout), optional ::  jdesc
    integer, intent(inout), optional ::  jnoma
    integer, intent(inout), optional ::  jncmp
    integer, intent(inout), optional ::  jnoli
    integer, intent(inout), optional ::  jvale
    integer, intent(inout), optional ::  jvalv
    integer, intent(in)   , optional ::  jnocmp
    integer, intent(in)   , optional ::  ncmpmx
    integer, intent(in)   , optional ::  nec
    character(len=8), intent(in), optional ::  ctype
    integer, intent(inout), optional ::  jlima0
    integer, intent(inout), optional ::  jlimac
    integer, intent(inout), optional ::  lontav

end subroutine nocart
end interface
