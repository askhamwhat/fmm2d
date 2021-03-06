      implicit real *8 (a-h,o-z)
      real *8, allocatable :: sources(:,:),targ(:,:)
      complex *16, allocatable :: charges(:),dipstr(:)
      complex *16, allocatable :: pot(:),grad(:),hess(:)
      real *8, allocatable :: potr(:),pottargr(:)
      complex *16, allocatable :: pottarg(:),gradtarg(:),hesstarg(:)

      complex *16, allocatable :: potex(:),gradex(:),hessex(:)
      real *8, allocatable :: potexr(:),pottargexr(:)
      complex *16, allocatable :: pottargex(:),gradtargex(:),
     1                             hesstargex(:)

      real *8 expc(100),texps(100),scj(100)
      
      complex *16 ima
      data ima/(0.0d0,1.0d0)/

      call prini(6,13)

      done = 1
      pi = atan(done)*4

      nsrc = 10000
      ntarg = nsrc

      allocate(sources(2,nsrc),charges(nsrc),dipstr(nsrc))
      allocate(targ(2,ntarg))
      allocate(pot(nsrc),grad(nsrc),hess(nsrc),potr(nsrc))
      allocate(pottarg(ntarg),gradtarg(ntarg),hesstarg(ntarg))
      allocate(pottargr(ntarg))

      do i=1,nsrc

         sources(1,i) = hkrand(0)
         sources(2,i) = hkrand(0)

         charges(i) = hkrand(0) 

         dipstr(i) = hkrand(0) + ima*hkrand(0)

      enddo



      do i=1,ntarg
         targ(1,i) = hkrand(0)
         targ(2,i) = hkrand(0)
      enddo

      nts = min(20,nsrc)
      ntt = min(20,ntarg)

      allocate(potex(nts),gradex(nts),hessex(nts),potexr(nts))
      allocate(pottargex(ntt),gradtargex(ntt),hesstargex(ntt))
      allocate(pottargexr(ntt))


c
cc      test low frequency mode
c
      eps = 0.5d-6
c
c
cc      now test source to source  + target, charge
c       with potentials
c
      write(6,*) 'testing stost, charge, potentials'

      call lfmm2d_st_c_p(eps,nsrc,sources,charges,
     1        pot,ntarg,targ,pottarg)


c
cc       test against exact potential
c
      call dzero(potex,2*nts)
      call dzero(pottargex,2*ntt)

      ifcharge = 1
      ifdipole = 0

      ifpgh = 1
      thresh = 1.0d-14

      call lfmm2dpart_direct_vec(1,1,nsrc,1,nts,sources,ifcharge,
     1       charges,ifdipole,dipstr,sources,ifpgh,potex,
     2       gradex,hessex,thresh)

      call lfmm2dpart_direct_vec(1,1,nsrc,1,ntt,sources,ifcharge,
     1       charges,ifdipole,dipstr,targ,ifpgh,pottargex,
     2       gradtargex,hesstargex,thresh)

      do i=1,nts
        potexr(i) = real(potex(i))
        potr(i) = real(pot(i))
      enddo

      do i=1,ntt
        pottargexr(i) = real(pottargex(i))
        pottargr(i) = real(pottarg(i))
      enddo
      call derr(potexr,potr,nts,errps)
      call derr(pottargexr,pottargr,ntt,errpt)

      errgs = 0
      errgt = 0

      errhs = 0
      errht = 0
      call errprint(errps,errgs,errhs,errpt,errgt,errht)




c
c
cc      now test source to source  + target, charge
c       with gradients
c
      write(6,*) 'testing stost, charge, gradients'

      call lfmm2d_st_c_g(eps,nsrc,sources,charges,
     1        pot,grad,ntarg,targ,pottarg,gradtarg)
c
cc       test against exact potential
c
      call dzero(potex,2*nts)
      call dzero(gradex,2*nts)
      call dzero(pottargex,2*ntt)
      call dzero(gradtargex,2*ntt)

      ifcharge = 1
      ifdipole = 0

      ifpgh = 2
      thresh = 1.0d-14

      call lfmm2dpart_direct_vec(1,1,nsrc,1,nts,sources,ifcharge,
     1       charges,ifdipole,dipstr,sources,ifpgh,potex,
     2       gradex,hessex,thresh)

      call lfmm2dpart_direct_vec(1,1,nsrc,1,ntt,sources,ifcharge,
     1       charges,ifdipole,dipstr,targ,ifpgh,pottargex,
     2       gradtargex,hesstargex,thresh)

      do i=1,nts
        potexr(i) = real(potex(i))
        potr(i) = real(pot(i))
      enddo

      do i=1,ntt
        pottargexr(i) = real(pottargex(i))
        pottargr(i) = real(pottarg(i))
      enddo
      call derr(potexr,potr,nts,errps)
      call derr(pottargexr,pottargr,ntt,errpt)

      call derr(gradex,grad,2*nts,errgs)
      call derr(gradtargex,gradtarg,2*ntt,errgt)

      errhs = 0
      errht = 0
      call errprint(errps,errgs,errhs,errpt,errgt,errht)

c
c
cc      now test source to source  + target, charge
c       with hessians
c



      write(6,*) 'testing stost, charge, hessians'
      call lfmm2d_st_c_h(eps,nsrc,sources,charges,
     1        pot,grad,hess,ntarg,targ,pottarg,gradtarg,
     2        hesstarg)
c
cc       test against exact potential
c
      call dzero(potex,2*nts)
      call dzero(gradex,2*nts)
      call dzero(hessex,2*nts)
      call dzero(pottargex,2*ntt)
      call dzero(gradtargex,2*ntt)
      call dzero(hesstargex,2*ntt)

      ifcharge = 1
      ifdipole = 0

      ifpgh = 3
      thresh = 1.0d-14

      call lfmm2dpart_direct_vec(1,1,nsrc,1,nts,sources,ifcharge,
     1       charges,ifdipole,dipstr,sources,ifpgh,potex,
     2       gradex,hessex,thresh)

      call lfmm2dpart_direct_vec(1,1,nsrc,1,ntt,sources,ifcharge,
     1       charges,ifdipole,dipstr,targ,ifpgh,pottargex,
     2       gradtargex,hesstargex,thresh)

      do i=1,nts
        potexr(i) = real(potex(i))
        potr(i) = real(pot(i))
      enddo

      do i=1,ntt
        pottargexr(i) = real(pottargex(i))
        pottargr(i) = real(pottarg(i))
      enddo

      call derr(potexr,potr,nts,errps)
      call derr(pottargexr,pottargr,ntt,errpt)

      call derr(gradex,grad,2*nts,errgs)
      call derr(hessex,hess,2*nts,errhs)
      call derr(gradtargex,gradtarg,2*ntt,errgt)
      call derr(hesstargex,hesstarg,2*nts,errht)

      call errprint(errps,errgs,errhs,errpt,errgt,errht)

c
c
c
c
cc      now test source to source  + target, dipole
c       with potentials
c
      write(6,*) 'testing stost, dipole, potentials'

      call lfmm2d_st_d_p(eps,nsrc,sources,dipstr,
     1        pot,ntarg,targ,pottarg)


c
cc       test against exact potential
c
      call dzero(potex,2*nts)
      call dzero(pottargex,2*ntt)

      ifcharge = 0
      ifdipole = 1

      ifpgh = 1
      thresh = 1.0d-14

      call lfmm2dpart_direct_vec(1,1,nsrc,1,nts,sources,ifcharge,
     1       charges,ifdipole,dipstr,sources,ifpgh,potex,
     2       gradex,hessex,thresh)

      call lfmm2dpart_direct_vec(1,1,nsrc,1,ntt,sources,ifcharge,
     1       charges,ifdipole,dipstr,targ,ifpgh,pottargex,
     2       gradtargex,hesstargex,thresh)

      do i=1,nts
        potexr(i) = real(potex(i))
        potr(i) = real(pot(i))
      enddo

      do i=1,ntt
        pottargexr(i) = real(pottargex(i))
        pottargr(i) = real(pottarg(i))
      enddo
      call derr(potexr,potr,nts,errps)
      call derr(pottargexr,pottargr,ntt,errpt)

  
      errgs = 0
      errgt = 0

      errhs = 0
      errht = 0
      call errprint(errps,errgs,errhs,errpt,errgt,errht)


c
c
cc      now test source to source  + target, dipole
c       with gradients
c
      write(6,*) 'testing stost, dipole, gradients'

      call lfmm2d_st_d_g(eps,nsrc,sources,dipstr,
     1        pot,grad,ntarg,targ,pottarg,gradtarg)
c
cc       test against exact potential
c
      call dzero(potex,2*nts)
      call dzero(gradex,2*nts)
      call dzero(pottargex,2*ntt)
      call dzero(gradtargex,2*ntt)

      ifcharge = 0
      ifdipole = 1

      ifpgh = 2
      thresh = 1.0d-14

      call lfmm2dpart_direct_vec(1,1,nsrc,1,nts,sources,ifcharge,
     1       charges,ifdipole,dipstr,sources,ifpgh,potex,
     2       gradex,hessex,thresh)

      call lfmm2dpart_direct_vec(1,1,nsrc,1,ntt,sources,ifcharge,
     1       charges,ifdipole,dipstr,targ,ifpgh,pottargex,
     2       gradtargex,hesstargex,thresh)

      do i=1,nts
        potexr(i) = real(potex(i))
        potr(i) = real(pot(i))
      enddo

      do i=1,ntt
        pottargexr(i) = real(pottargex(i))
        pottargr(i) = real(pottarg(i))
      enddo
      call derr(potexr,potr,nts,errps)
      call derr(pottargexr,pottargr,ntt,errpt)

      call derr(gradex,grad,2*nts,errgs)
      call derr(gradtargex,gradtarg,2*ntt,errgt)

      errhs = 0
      errht = 0
      call errprint(errps,errgs,errhs,errpt,errgt,errht)

c
c
cc      now test source to source  + target, dipole
c       with hessians
c



      write(6,*) 'testing stost, dipole, hessians'
      call lfmm2d_st_d_h(eps,nsrc,sources,dipstr,
     1        pot,grad,hess,ntarg,targ,pottarg,gradtarg,
     2        hesstarg)
c
cc       test against exact potential
c
      call dzero(potex,2*nts)
      call dzero(gradex,2*nts)
      call dzero(hessex,2*nts)
      call dzero(pottargex,2*ntt)
      call dzero(gradtargex,2*ntt)
      call dzero(hesstargex,2*ntt)

      ifcharge = 0
      ifdipole = 1

      ifpgh = 3
      thresh = 1.0d-14

      call lfmm2dpart_direct_vec(1,1,nsrc,1,nts,sources,ifcharge,
     1       charges,ifdipole,dipstr,sources,ifpgh,potex,
     2       gradex,hessex,thresh)

      call lfmm2dpart_direct_vec(1,1,nsrc,1,ntt,sources,ifcharge,
     1       charges,ifdipole,dipstr,targ,ifpgh,pottargex,
     2       gradtargex,hesstargex,thresh)

      do i=1,nts
        potexr(i) = real(potex(i))
        potr(i) = real(pot(i))
      enddo

      do i=1,ntt
        pottargexr(i) = real(pottargex(i))
        pottargr(i) = real(pottarg(i))
      enddo
      call derr(potexr,potr,nts,errps)
      call derr(pottargexr,pottargr,ntt,errpt)

      call derr(gradex,grad,2*nts,errgs)
      call derr(hessex,hess,2*nts,errhs)
      call derr(gradtargex,gradtarg,2*ntt,errgt)
      call derr(hesstargex,hesstarg,2*nts,errht)

      call errprint(errps,errgs,errhs,errpt,errgt,errht)
c
c
c
c
cc      now test source to source  + target, charge + dipole
c       with potentials
c
      write(6,*) 'testing stost, charge + dipole, potentials'

      call lfmm2d_st_cd_p(eps,nsrc,sources,charges,dipstr,
     1        pot,ntarg,targ,pottarg)
c
cc       test against exact potential
c
      call dzero(potex,2*nts)
      call dzero(pottargex,2*ntt)

      ifcharge = 1
      ifdipole = 1

      ifpgh = 1
      thresh = 1.0d-14

      call lfmm2dpart_direct_vec(1,1,nsrc,1,nts,sources,ifcharge,
     1       charges,ifdipole,dipstr,sources,ifpgh,potex,
     2       gradex,hessex,thresh)

      call lfmm2dpart_direct_vec(1,1,nsrc,1,ntt,sources,ifcharge,
     1       charges,ifdipole,dipstr,targ,ifpgh,pottargex,
     2       gradtargex,hesstargex,thresh)

      do i=1,nts
        potexr(i) = real(potex(i))
        potr(i) = real(pot(i))
      enddo

      do i=1,ntt
        pottargexr(i) = real(pottargex(i))
        pottargr(i) = real(pottarg(i))
      enddo
      call derr(potexr,potr,nts,errps)
      call derr(pottargexr,pottargr,ntt,errpt)

  
      errgs = 0
      errgt = 0

      errhs = 0
      errht = 0
      call errprint(errps,errgs,errhs,errpt,errgt,errht)


c
c
cc      now test source to source  + target, charge + dipole
c       with gradients
c
      write(6,*) 'testing stost, charge + dipole, gradients'

      call lfmm2d_st_cd_g(eps,nsrc,sources,charges,dipstr,
     1        pot,grad,ntarg,targ,pottarg,gradtarg)
c
cc       test against exact potential
c
      call dzero(potex,2*nts)
      call dzero(gradex,2*nts)
      call dzero(pottargex,2*ntt)
      call dzero(gradtargex,2*ntt)

      ifcharge = 1
      ifdipole = 1

      ifpgh = 2
      thresh = 1.0d-14

      call lfmm2dpart_direct_vec(1,1,nsrc,1,nts,sources,ifcharge,
     1       charges,ifdipole,dipstr,sources,ifpgh,potex,
     2       gradex,hessex,thresh)

      call lfmm2dpart_direct_vec(1,1,nsrc,1,ntt,sources,ifcharge,
     1       charges,ifdipole,dipstr,targ,ifpgh,pottargex,
     2       gradtargex,hesstargex,thresh)

      do i=1,nts
        potexr(i) = real(potex(i))
        potr(i) = real(pot(i))
      enddo

      do i=1,ntt
        pottargexr(i) = real(pottargex(i))
        pottargr(i) = real(pottarg(i))
      enddo
      call derr(potexr,potr,nts,errps)
      call derr(pottargexr,pottargr,ntt,errpt)

      call derr(gradex,grad,2*nts,errgs)
      call derr(gradtargex,gradtarg,2*ntt,errgt)

      errhs = 0
      errht = 0
      call errprint(errps,errgs,errhs,errpt,errgt,errht)

c
c
cc      now test source to source  + target, charge + dipole
c       with hessians
c



      write(6,*) 'testing stost, charge + dipole, hessians'
      call lfmm2d_st_cd_h(eps,nsrc,sources,charges,dipstr,
     1        pot,grad,hess,ntarg,targ,pottarg,gradtarg,
     2        hesstarg)
c
cc       test against exact potential
c
      call dzero(potex,2*nts)
      call dzero(gradex,2*nts)
      call dzero(hessex,2*nts)
      call dzero(pottargex,2*ntt)
      call dzero(gradtargex,2*ntt)
      call dzero(hesstargex,2*ntt)

      ifcharge = 1
      ifdipole = 1

      ifpgh = 3
      thresh = 1.0d-14

      call lfmm2dpart_direct_vec(1,1,nsrc,1,nts,sources,ifcharge,
     1       charges,ifdipole,dipstr,sources,ifpgh,potex,
     2       gradex,hessex,thresh)

      call lfmm2dpart_direct_vec(1,1,nsrc,1,ntt,sources,ifcharge,
     1       charges,ifdipole,dipstr,targ,ifpgh,pottargex,
     2       gradtargex,hesstargex,thresh)

      do i=1,nts
        potexr(i) = real(potex(i))
        potr(i) = real(pot(i))
      enddo

      do i=1,ntt
        pottargexr(i) = real(pottargex(i))
        pottargr(i) = real(pottarg(i))
      enddo
      call derr(potexr,potr,nts,errps)
      call derr(pottargexr,pottargr,ntt,errpt)

      call derr(gradex,grad,2*nts,errgs)
      call derr(hessex,hess,2*nts,errhs)
      call derr(gradtargex,gradtarg,2*ntt,errgt)
      call derr(hesstargex,hesstarg,2*nts,errht)

      call errprint(errps,errgs,errhs,errpt,errgt,errht)

      stop
      end
c-----------------------------------------------------     
      subroutine dzero(vec,n)
      implicit real *8 (a-h,o-z)
      real *8 vec(*)

      do i=1,n
         vec(i) = 0
      enddo

      return
      end
c------------------------------------
      subroutine derr(vec1,vec2,n,erra)
      implicit real *8 (a-h,o-z)
      real *8 vec1(*),vec2(*)

      ra = 0
      erra = 0
      do i=1,n
         ra = ra + vec1(i)**2
         erra = erra + (vec1(i)-vec2(i))**2
      enddo

      erra = sqrt(erra/ra)

      return
      end
c----------------------------------
      subroutine errprint(errps,errgs,errhs,errpt,errgt,errht)
      implicit real *8 (a-h,o-z)
 1100 format(3(2x,e11.5))


      write(6,*) 'error in sources'
      write(6,*) 'pot err, grad err, hess err' 
      write(6,1100) errps,errgs,errhs
      write(6,*) 
      write(6,*)
      write(6,* ) 'error in targets'
      write(6,*) 'pot err, grad err, hess err' 
      write(6,1100) errpt,errgt,errht
      write(6,*)
      write(6,*)
      write(6,*)'==================='

      return
      end
      
