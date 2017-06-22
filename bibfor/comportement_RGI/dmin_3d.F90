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

subroutine dmin_3d(d03, df3)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!     verif explicite de la condition de croissance de micro defaut
!     variables externes
!=====================================================================
    implicit none
    real(kind=8) :: d03(3), df3(3)
!     variables locales
    integer :: imini0, imaxi0, imoy0, iminif, imaxif, imoyf
!
!     recherche des indices croissants ds d0
!     recherche de lindice de dmin
    imini0=1
    if (d03(2) .lt. d03(imini0)) imini0=2
    if (d03(3) .lt. d03(imini0)) imini0=3
!     recherche de l indice de dmax
    imaxi0=1
    if (d03(2) .ge. d03(imaxi0)) imaxi0=2
    if (d03(3) .ge. d03(imaxi0)) imaxi0=3
    imoy0=6-(imini0+imaxi0)
!      print*,imini0,imoy0,imaxi0,D03(imini0),d03(imoy0),d03(imaxi0)
!     recherche des indices croissants ds df
    iminif=1
    if (df3(2) .lt. df3(iminif)) iminif=2
    if (df3(3) .lt. df3(iminif)) iminif=3
    imaxif=1
    if (df3(2) .ge. df3(imaxif)) imaxif=2
    if (df3(3) .ge. df3(imaxif)) imaxif=3
    imoyf=6-(iminif+imaxif)
!      print*,iminif,imoyf,imaxif,df3(iminif),df3(imoyf),df3(imaxif)
!      print*
!
!     verif des conditions de croissance des valeurs principales
    if (df3(iminif) .lt. d03(imini0)) then
!       print*,'dD>0 actif ds b3d_util dmin_3D pour dmin'
!       print*,df3(iminif),d03(imini0),df3(iminif)-d03(imini0)
!       print*,imini0,imoy0,imaxi0,d03(imini0),d03(imoy0),d03(imaxi0)
!       print*,iminif,imoyf,imaxif,Df3(iminif),df3(imoyf),df3(imaxif)
!       read*
        df3(iminif)=d03(imini0)
    end if
    if (df3(imoyf) .lt. d03(imoy0)) then
!       print*,'dD>0 actif ds b3d_util dmin_3D pour dmoy'
!       print*,df3(imoyf),d03(imoy0),df3(imoyf)-d03(imoy0)
!       print*,imini0,imoy0,imaxi0,d03(imini0),d03(imoy0),d03(imaxi0)
!       print*,iminif,imoyf,imaxif,Df3(iminif),df3(imoyf),df3(imaxif)
!       read*
        df3(imoyf)=d03(imoy0)
    end if
    if (df3(imaxif) .lt. d03(imaxi0)) then
!       print*,'dD>0 actif ds b3d_util dmin_3D pour dmax'
!       print*,df3(imaxif),d03(imaxi0),df3(imaxif)-d03(imaxi0)
!       print*,imini0,imoy0,imaxi0,d03(imini0),d03(imoy0),d03(imaxi0)
!       print*,iminif,imoyf,imaxif,Df3(iminif),df3(imoyf),df3(imaxif)
!       read*
        df3(imaxif)=d03(imaxi0)
    end if
!      print*,df3(1),df3(2),df3(3)
!      read*
end subroutine
