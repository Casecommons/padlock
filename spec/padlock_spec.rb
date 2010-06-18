require File.join(File.dirname(__FILE__), *%w[.. lib padlock])

describe Padlock('development') do
  include Padlock

  it "has an environment" do
    Padlock.environment = "development"
    Padlock.environment.should == "development"
  end

  it "raises a ComponentNotFound error when the component don't not exist none" do
    proc {
      component(:raptor_fences)
    }.should raise_error(Padlock::ComponentNotFound)
  end

  describe "defining enabled components" do
    context "when not specifying environments" do
      before(:each) do
        Padlock('development') do
          enable :perimeter_fence
        end
      end

      it "runs the component block always" do
        called = false
        component(:perimeter_fence) { called = true }
        called.should be_true
      end

      it "always returns true on component check" do
        component(:perimeter_fence).should be_true
      end
    end

    context "when specifying environment" do
      before(:each) do
        Padlock('development') do
          enable :perimeter_fence, :in => :development
        end
      end

      context "when in appropriate environment" do
        before(:each) do
          Padlock.environment = 'development'
        end

        it "runs the component block" do
          called = false
          component(:perimeter_fence) { called = true }
          called.should be_true
        end

        it "returns true from the component check" do
          component(:perimeter_fence).should be_true
        end

        it "is indifferent to strings/symbols" do
          Padlock('development') do
            enable :perimeter_fence, :in => 'development'
          end

          called = false
          component(:perimeter_fence) { called = true }
          called.should be_true
        end
      end
    end

    context "when specifying multiple environments" do
      before(:each) do
        Padlock('development') do
          enable :perimeter_fence, :in => [:development, :test]
        end
      end

      context "when in appropriate environment" do
        before(:each) do
          Padlock.environment = 'development'
        end

        it "runs the component block" do
          called = false
          component(:perimeter_fence) { called = true }
          called.should be_true
        end

        it "returns true from the component check" do
          component(:perimeter_fence).should be_true
        end

        it "is indifferent to strings/symbols" do
          Padlock('development') do
            enable :perimeter_fence, :in => %w[development test]
          end

          called = false
          component(:perimeter_fence) { called = true }
          called.should be_true
        end
      end

      context "when not in appropriate environment" do
        before(:each) do
          Padlock.environment = 'production'
        end

        it "does not run the component block when not in an appropriate environment" do
          called = false
          component(:perimeter_fence) { called = true }
          called.should be_false
        end

        it "returns false from the component check" do
          component(:perimeter_fence).should be_false
        end
      end
    end
  end

  describe "disabling components" do
    before(:each) do
      Padlock('development') do
        disable :perimeter_fence
      end
    end

    it "does not run the component block when not in an appropriate environment" do
      called = false
      component(:perimeter_fence) { called = true }
      called.should be_false
    end

    it "returns false from the component check" do
      component(:perimeter_fence).should be_false
    end
  end

  describe "disabling components in certain environments" do
    before(:each) do
      Padlock('production') do
        disable :perimeter_fence, :in => :production
      end
    end

    it "does not run the component block when not in an appropriate environment" do
      called = false
      component(:perimeter_fence) { called = true }
      called.should be_false
    end

    it "returns false from the component check" do
      component(:perimeter_fence).should be_false
    end

    it "is indifferent to strings/symbols" do
      Padlock('development') do
        disable :perimeter_fence, :in => 'production'
      end

      called = false
      component(:perimeter_fence) { called = true }
      called.should be_true
    end
  end

  describe "using disabled components in different environment" do
    before(:each) do
      Padlock('development') do
        disable :perimeter_fence, :in => :production
      end
    end

    it "does not run the component block when not in an appropriate environment" do
      called = false
      component(:perimeter_fence) { called = true }
      called.should be_true
    end

    it "returns false from the component check" do
      component(:perimeter_fence).should be_true
    end

    it "is indifferent to strings/symbols" do
      Padlock('development') do
        disable :perimeter_fence, :in => %w[production other]
      end

      called = false
      component(:perimeter_fence) { called = true }
      called.should be_true
    end
  end

  describe "resetting changes" do
    before(:each) do
      Padlock('development') do
        disable :disabled_component
        enable :enabled_component
      end
    end

    it "restores original component behavior" do
      Padlock.disable :enabled_component
      component(:enabled_component).should be_false

      Padlock.reset!
      component(:enabled_component).should be_true
    end
  end
end
