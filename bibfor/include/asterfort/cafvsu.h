!
! COPYRIGHT (C) 1991 - 2013  EDF R&D                WWW.CODE-ASTER.ORG
!
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
! 1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
!
#include "asterf_types.h"
!
interface
    subroutine cafvsu(cont, tange, maxfa, nface, fks,&
                      dfks1, dfks2, mobfa, dmob1, dmob2,&
                      dmob1v, dmob2v, flux, dflx1, dflx2,&
                      dflx1v, dflx2v, nbvois, nvoima)
        integer :: nvoima
        integer :: nface
        integer :: maxfa
        aster_logical :: cont
        aster_logical :: tange
        real(kind=8) :: fks(1:nface)
        real(kind=8) :: dfks1(1:maxfa+1, nface)
        real(kind=8) :: dfks2(1:maxfa+1, nface)
        real(kind=8) :: mobfa(0:nvoima, 1:nface)
        real(kind=8) :: dmob1(0:nvoima, 1:nface)
        real(kind=8) :: dmob2(0:nvoima, 1:nface)
        real(kind=8) :: dmob1v(0:nvoima, 1:nface)
        real(kind=8) :: dmob2v(0:nvoima, 1:nface)
        real(kind=8) :: flux
        real(kind=8) :: dflx1(1:nface+1)
        real(kind=8) :: dflx2(1:nface+1)
        real(kind=8) :: dflx1v(1:nface)
        real(kind=8) :: dflx2v(1:nface)
        integer :: nbvois
    end subroutine cafvsu
end interface
