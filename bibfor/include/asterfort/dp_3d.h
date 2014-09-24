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
    subroutine dp_3d(xj2d, xi1, cohe1, delta1, beta1,&
                     h1, cohemin, fdp1, cohe2, delta2,&
                     beta2, h2)
        real(kind=8) :: xj2d
        real(kind=8) :: xi1
        real(kind=8) :: cohe1
        real(kind=8) :: delta1
        real(kind=8) :: beta1
        real(kind=8) :: h1
        real(kind=8) :: cohemin
        real(kind=8) :: fdp1
        real(kind=8) :: delta2
        real(kind=8) :: beta2
        real(kind=8) :: cohe2
        real(kind=8) :: h2
    end subroutine dp_3d
end interface 
