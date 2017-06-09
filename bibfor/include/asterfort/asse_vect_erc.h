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
    subroutine asse_vect_erc(baseno,nom_vect_erc,nommes,matobs, obsdim, alpha,n_ordre_mes,omega)
        
    character(len=8),intent(in) :: nommes,baseno
    character(len=19),intent(in) :: nom_vect_erc
    integer,intent(in) :: obsdim(3),n_ordre_mes
    real(kind=8),intent(in) :: alpha,omega
    character(len=24),intent(in) :: matobs(3)
        
    end subroutine  asse_vect_erc
end interface 
