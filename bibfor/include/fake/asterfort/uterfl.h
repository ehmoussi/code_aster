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
interface
    subroutine uterfl(ndim, iflup, iflum, ino, mno,&
                      jno, nsomm, jac, term22, aux,&
                      ltheta, valthe, valunt, niv, ifm,&
                      xn, yn, zn, valfp, valfm,&
                      ityp, noe)
        integer :: ndim
        integer :: iflup
        integer :: iflum
        integer :: ino
        integer :: mno
        integer :: jno
        integer :: nsomm
        real(kind=8) :: jac(9)
        real(kind=8) :: term22
        real(kind=8) :: aux
        logical :: ltheta
        real(kind=8) :: valthe
        real(kind=8) :: valunt
        integer :: niv
        integer :: ifm
        real(kind=8) :: xn(9)
        real(kind=8) :: yn(9)
        real(kind=8) :: zn(9)
        real(kind=8) :: valfp(9)
        real(kind=8) :: valfm(9)
        integer :: ityp
        integer :: noe(9, 6, 3)
    end subroutine uterfl
end interface
